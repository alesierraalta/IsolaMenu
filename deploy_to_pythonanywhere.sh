#!/bin/bash

# Variables
PA_USER=${PYTHONANYWHERE_USERNAME}
PA_API_TOKEN=${PYTHONANYWHERE_API_TOKEN}
PROJECT_DIR="/home/$PA_USER/IsolaMenu"  # Ruta del proyecto en PythonAnywhere
REPO_NAME=${GITHUB_REPOSITORY##*/}

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

# Desempaquetar el tarball en PythonAnywhere y recargar la aplicación web
debug "Ejecutando comandos de despliegue en PythonAnywhere..."
deploy_output=$(curl -X POST -H "Authorization: Token ${PA_API_TOKEN}" \
  -d "commands=cd /home/${PA_USER} && \
  tar xzf ${REPO_NAME}.tar.gz && \
  rm ${REPO_NAME}.tar.gz && \
  cd ${PROJECT_DIR} && \
  source /home/${PA_USER}/.virtualenvs/your_virtualenv/bin/activate && \
  pip install -r requirements.txt && \
  python manage.py collectstatic --noinput && \
  python manage.py migrate && \
  pa_reload_webapp your_webapp_name.pythonanywhere.com" \
  "https://www.pythonanywhere.com/api/v0/user/${PA_USER}/consoles/?start_bash_console=true")

if [[ $deploy_output == *"\"status\": \"ok\""* ]]; then
  debug "Despliegue completado con éxito"
else
  debug "Error: Falló la ejecución de comandos en PythonAnywhere"
  debug "Salida: $deploy_output"
  exit 1
fi
