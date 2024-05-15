#!/bin/bash

# Variables
PA_USER=${PYTHONANYWHERE_USERNAME}
PA_API_TOKEN=${PYTHONANYWHERE_API_TOKEN}
PROJECT_DIR=/home/$PA_USER/IsolaMenu  # Ruta del proyecto en PythonAnywhere
REPO_NAME=${GITHUB_REPOSITORY##*/}

# Subir el código a PythonAnywhere
echo "Subiendo el código a PythonAnywhere..."
tar czf /tmp/${REPO_NAME}.tar.gz .
curl -X POST -F "content=@/tmp/${REPO_NAME}.tar.gz" -H "Authorization: Token ${PA_API_TOKEN}" "https://www.pythonanywhere.com/api/v0/user/${PA_USER}/files/path/home/${PA_USER}/${REPO_NAME}.tar.gz"

# Crear el directorio ~/.ssh si no existe
mkdir -p /home/runner/.ssh

# Añadir la clave del host de PythonAnywhere al archivo known_hosts
ssh-keyscan -H ssh.pythonanywhere.com >> /home/runner/.ssh/known_hosts

# Desempaquetar el tarball en PythonAnywhere y recargar la aplicación web
ssh -o StrictHostKeyChecking=no ${PA_USER}@ssh.pythonanywhere.com <<EOF
  cd ${PROJECT_DIR}
  tar xzf /home/${PA_USER}/${REPO_NAME}.tar.gz
  rm /home/${PA_USER}/${REPO_NAME}.tar.gz
  workon your_virtualenv  # Activa tu entorno virtual
  pip install -r Backend/requirements.txt
  python Backend/manage.py collectstatic --noinput
  python Backend/manage.py migrate
  pa_reload_webapp your_webapp_name.pythonanywhere.com
EOF
