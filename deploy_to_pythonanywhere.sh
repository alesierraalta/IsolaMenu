#!/bin/bash

# Variables
PA_USER=${PYTHONANYWHERE_USERNAME}
PROJECT_DIR="/home/$PA_USER/IsolaMenu"  # Ruta del proyecto en PythonAnywhere
REPO_NAME=${GITHUB_REPOSITORY##*/}

# Subir el código a PythonAnywhere
echo "Subiendo el código a PythonAnywhere..."
tar czf /tmp/${REPO_NAME}.tar.gz .
curl -X POST -F "content=@/tmp/${REPO_NAME}.tar.gz" -H "Authorization: Token ${PYTHONANYWHERE_API_TOKEN}" "https://www.pythonanywhere.com/api/v0/user/${PA_USER}/files/path/home/${PA_USER}/${REPO_NAME}.tar.gz"

# Crear el directorio ~/.ssh si no existe
mkdir -p ~/.ssh

# Añadir la clave del host de PythonAnywhere al archivo known_hosts
ssh-keyscan -H ssh.pythonanywhere.com >> ~/.ssh/known_hosts

# Configurar la clave privada SSH
echo "${PYTHONANYWHERE_SSH_KEY}" | tr -d '\r' > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Probar la conexión SSH
echo "Probando la conexión SSH..."
ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -v ${PA_USER}@ssh.pythonanywhere.com "echo 'Conexión SSH exitosa'"

# Desempaquetar el tarball en PythonAnywhere y recargar la aplicación web
ssh -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no ${PA_USER}@ssh.pythonanywhere.com << EOF
  cd /home/${PA_USER}/IsolaMenu
  tar xzf /home/${PA_USER}/${REPO_NAME}.tar.gz -C /home/${PA_USER}/IsolaMenu
  rm /home/${PA_USER}/${REPO_NAME}.tar.gz
  source /home/${PA_USER}/.virtualenvs/your_virtualenv/bin/activate  # Activa tu entorno virtual
  pip install -r /home/${PA_USER}/IsolaMenu/Backend/requirements.txt
  python /home/${PA_USER}/IsolaMenu/Backend/manage.py collectstatic --noinput
  python /home/${PA_USER}/IsolaMenu/Backend/manage.py migrate
  pa_reload_webapp your_webapp_name.pythonanywhere.com
EOF
