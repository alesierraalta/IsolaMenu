#!/bin/bash

# Variables
PA_USER=${PYTHONANYWHERE_USERNAME}
PROJECT_DIR="/home/$PA_USER/IsolaMenu"  # Ruta del proyecto en PythonAnywhere
REPO_NAME=${GITHUB_REPOSITORY##*/}

# Función de depuración
debug() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*"
}

# Subir el código a PythonAnywhere
debug "Subiendo el código a PythonAnywhere..."
tar czf /tmp/${REPO_NAME}.tar.gz .
curl -X POST -F "content=@/tmp/${REPO_NAME}.tar.gz" -H "Authorization: Token ${PYTHONANYWHERE_API_TOKEN}" "https://www.pythonanywhere.com/api/v0/user/${PA_USER}/files/path/home/${PA_USER}/${REPO_NAME}.tar.gz" || { debug "Error: Falló la subida del código a PythonAnywhere"; exit 1; }

# Crear el directorio ~/.ssh si no existe
mkdir -p ~/.ssh || { debug "Error: Falló la creación del directorio ~/.ssh"; exit 1; }

# Añadir la clave del host de PythonAnywhere al archivo known_hosts
ssh-keyscan -H ssh.pythonanywhere.com >> ~/.ssh/known_hosts || { debug "Error: Falló la adición de la clave del host de PythonAnywhere"; exit 1; }

# Configurar la clave privada SSH
echo "${PYTHONANYWHERE_SSH_KEY}" | tr -d '\r' > ~/.ssh/id_rsa || { debug "Error: Falló la configuración de la clave privada SSH"; exit 1; }
chmod 600 ~/.ssh/id_rsa || { debug "Error: Falló la configuración de permisos para la clave privada SSH"; exit 1; }

# Probar la conexión SSH
debug "Probando la conexión SSH..."
ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -v ${PA_USER}@ssh.pythonanywhere.com "echo 'Conexión SSH exitosa'" || { debug "Error: Falló la prueba de conexión SSH"; exit 1; }

# Desempaquetar el tarball en PythonAnywhere y recargar la aplicación web
debug "Ejecutando comandos de despliegue en PythonAnywhere..."
ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ${PA_USER}@ssh.pythonanywhere.com << EOF
  echo "Conectado a PythonAnywhere"
  cd /home/${PA_USER}/IsolaMenu || { echo "Error: No se pudo cambiar al directorio del proyecto"; exit 1; }
  tar xzf /home/${PA_USER}/${REPO_NAME}.tar.gz -C /home/${PA_USER}/IsolaMenu || { echo "Error: No se pudo descomprimir el tarball"; exit 1; }
  rm /home/${PA_USER}/${REPO_NAME}.tar.gz || { echo "Error: No se pudo eliminar el tarball"; exit 1; }
  source /home/${PA_USER}/.virtualenvs/your_virtualenv/bin/activate || { echo "Error: No se pudo activar el entorno virtual"; exit 1; }
  pip install -r /home/${PA_USER}/IsolaMenu/Backend/requirements.txt || { echo "Error: No se pudieron instalar los requerimientos"; exit 1; }
  python /home/${PA_USER}/IsolaMenu/Backend/manage.py collectstatic --noinput || { echo "Error: Falló collectstatic"; exit 1; }
  python /home/${PA_USER}/IsolaMenu/Backend/manage.py migrate || { echo "Error: Falló migrate"; exit 1; }
  pa_reload_webapp your_webapp_name.pythonanywhere.com || { echo "Error: Falló pa_reload_webapp"; exit 1; }
  echo "Despliegue completado con éxito"
EOF || { debug "Error: Falló la ejecución de comandos en PythonAnywhere"; exit 1; }

debug "Despliegue completado con éxito"
