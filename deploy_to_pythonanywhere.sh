#!/bin/bash

# Variables
PA_USER=${PYTHONANYWHERE_USERNAME}
PA_API_TOKEN=${PYTHONANYWHERE_API_TOKEN}
REPO_NAME=${GITHUB_REPOSITORY##*/}
PROJECT_DIR="/home/$PA_USER/IsolaMenu"

# Función de depuración
debug() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*"
}

# Subir el código a PythonAnywhere
debug "Subiendo el código a PythonAnywhere..."
tar czf /tmp/${REPO_NAME}.tar.gz .
if curl -X POST -F "content=@/tmp/${REPO_NAME}.tar.gz" -H "Authorization: Token ${PA_API_TOKEN}" "https://www.pythonanywhere.com/api/v0/user/${PA_USER}/files/path/home/${PA_USER}/${REPO_NAME}.tar.gz"; then
  debug "Código subido correctamente."
else
  debug "Error: Falló la subida del código a PythonAnywhere"
  exit 1
fi

# Obtener consolas activas y matarlas
debug "Obteniendo consolas activas..."
active_consoles=$(curl -s -H "Authorization: Token ${PA_API_TOKEN}" "https://www.pythonanywhere.com/api/v0/user/${PA_USER}/consoles/")
console_ids=$(echo $active_consoles | jq -r '.[].id')
for console_id in $console_ids; do
  debug "Matando consola ID: $console_id"
  curl -X DELETE -H "Authorization: Token ${PA_API_TOKEN}" "https://www.pythonanywhere.com/api/v0/user/${PA_USER}/consoles/$console_id/"
done

# Ejecutar comandos de despliegue en una nueva consola Bash
debug "Ejecutando comandos de despliegue en PythonAnywhere..."
deploy_commands="cd /home/${PA_USER} && \
  tar xzf ${REPO_NAME}.tar.gz && \
  rm ${REPO_NAME}.tar.gz && \
  cd ${PROJECT_DIR} && \
  source /home/${PA_USER}/.virtualenvs/your_virtualenv/bin/activate && \
  pip install -r requirements.txt && \
  python manage.py collectstatic --noinput && \
  python manage.py migrate && \
  pa_reload_webapp your_webapp_name.pythonanywhere.com"

deploy_output=$(curl -s -X POST -H "Authorization: Token ${PA_API_TOKEN}" \
  -d "executable=/bin/bash" \
  -d "arguments=-c \"$deploy_commands\"" \
  "https://www.pythonanywhere.com/api/v0/user/${PA_USER}/consoles/?start_bash_console=true")

if [[ $deploy_output == *"\"status\": \"ok\""* ]]; then
  debug "Despliegue completado con éxito"
else
  debug "Error: Falló la ejecución de comandos en PythonAnywhere"
  debug "Salida: $deploy_output"
  exit 1
fi
