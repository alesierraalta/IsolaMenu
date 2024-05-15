#!/bin/bash

# Habilitar "set -e" para detener el script si ocurre algún error
set -e

# Función para mostrar mensajes de depuración
debug() {
  echo "[DEBUG $(date +'%Y-%m-%dT%H:%M:%S%z')]: $*"
}

# Verificar variables de entorno
if [[ -z "$PYTHONANYWHERE_USERNAME" || -z "$PYTHONANYWHERE_API_TOKEN" ]]; then
  echo "[ERROR]: PYTHONANYWHERE_USERNAME y PYTHONANYWHERE_API_TOKEN deben estar configurados."
  exit 1
fi

# Parámetros de despliegue
REPO_NAME="IsolaMenu"
PROJECT_DIR="IsolaMenu"
TAR_FILE="${REPO_NAME}.tar.gz"

# Subir el archivo a PythonAnywhere
debug "Subiendo el código a PythonAnywhere..."
upload_response=$(curl -s -w "%{http_code}" -o /dev/null -F "file=@${TAR_FILE}" -H "Authorization: Token ${PYTHONANYWHERE_API_TOKEN}" "https://www.pythonanywhere.com/api/v0/user/${PYTHONANYWHERE_USERNAME}/files/path/home/${PYTHONANYWHERE_USERNAME}/${TAR_FILE}")

if [[ $upload_response -ne 200 ]]; then
  echo "[ERROR]: Falló la subida del archivo. No se pudo porque: el código de respuesta HTTP fue $upload_response. Esto puede deberse a problemas de red, autenticación fallida, o un archivo demasiado grande."
  exit 1
fi

debug "Código subido correctamente."

# Obtener consolas activas
debug "Obteniendo consolas activas..."
active_consoles=$(curl -s -H "Authorization: Token ${PYTHONANYWHERE_API_TOKEN}" "https://www.pythonanywhere.com/api/v0/user/${PYTHONANYWHERE_USERNAME}/consoles/")
if [[ $? -ne 0 ]]; then
  echo "[ERROR]: No se pudieron obtener las consolas activas. No se pudo porque: puede haber un problema con la conexión a la API de PythonAnywhere o el token de autenticación no es válido."
  exit 1
fi

console_ids=$(echo $active_consoles | jq -r '.[].id')
for console_id in $console_ids; do
  debug "Matando consola ID: $console_id"
  kill_response=$(curl -s -w "%{http_code}" -o /dev/null -X DELETE -H "Authorization: Token ${PYTHONANYWHERE_API_TOKEN}" "https://www.pythonanywhere.com/api/v0/user/${PYTHONANYWHERE_USERNAME}/consoles/$console_id/")
  if [[ $kill_response -ne 204 ]]; then
    echo "[ERROR]: Falló al matar la consola ID: $console_id. No se pudo porque: el código de respuesta HTTP fue $kill_response. Esto puede deberse a que la consola no existe o problemas de autenticación."
    exit 1
  fi
done

# Comandos de despliegue
debug "Ejecutando comandos de despliegue en PythonAnywhere..."
deploy_commands=$(cat <<EOF
cd /home/${PYTHONANYWHERE_USERNAME} && \
tar xzf ${TAR_FILE} && \
rm ${TAR_FILE} && \
cd ${PROJECT_DIR} && \
source /home/${PYTHONANYWHERE_USERNAME}/.virtualenvs/your_virtualenv/bin/activate && \
pip install -r requirements.txt && \
python manage.py collectstatic --noinput && \
python manage.py migrate && \
pa_reload_webapp your_webapp_name.pythonanywhere.com
EOF
)

execute_response=$(curl -s -w "%{http_code}" -o /dev/null -X POST -H "Authorization: Token ${PYTHONANYWHERE_API_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "{\"executable\":\"/bin/bash\", \"arguments\":\"-c \\\"${deploy_commands}\\\"\"}" \
  "https://www.pythonanywhere.com/api/v0/user/${PYTHONANYWHERE_USERNAME}/consoles/")

if [[ $? -ne 0 ]]; then
  echo "[ERROR]: Falló la ejecución de comandos en PythonAnywhere. No se pudo porque: puede haber un problema con la conexión a la API de PythonAnywhere o los comandos de despliegue pueden estar mal formateados."
  exit 1
fi

debug "Comandos de despliegue ejecutados correctamente."
