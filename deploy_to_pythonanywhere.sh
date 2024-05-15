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
if curl -X POST -F "content=@/tmp/${REPO_NAME}.tar.gz" -H "Authorization: Token ${PYTHONANYWHERE_API_TOKEN}" "https://www.pythonanywhere.com/api/v0/user/${PA_USER}/files/path${PROJECT_DIR}/${REPO_NAME}.tar.gz"; then
  debug "Código subido correctamente."
else
  debug "Error: Falló la subida del código a PythonAnywhere"
  exit 1
fi

# Crear el directorio ~/.ssh si no existe
if mkdir -p ~/.ssh; then
  debug "Directorio ~/.ssh creado correctamente."
else
  debug "Error: Falló la creación del directorio ~/.ssh"
  exit 1
fi

# Añadir la clave del host de PythonAnywhere al archivo known_hosts
if ssh-keyscan -H ssh.pythonanywhere.com >> ~/.ssh/known_hosts; then
  debug "Clave del host de PythonAnywhere añadida correctamente."
else
  debug "Error: Falló la adición de la clave del host de PythonAnywhere"
  exit 1
fi

# Configurar la clave privada SSH
if echo "${PYTHONANYWHERE_SSH_KEY}" | tr -d '\r' > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa; then
  debug "Clave privada SSH configurada correctamente."
else
  debug "Error: Falló la configuración de la clave privada SSH"
  exit 1
fi

# Probar la conexión SSH con depuración avanzada
debug "Probando la conexión SSH..."
ssh_output=$(ssh -vvv -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -T ${PA_USER}@ssh.pythonanywhere.com "echo 'Conexión SSH exitosa'" 2>&1)
ssh_exit_code=$?

if [ $ssh_exit_code -eq 0 ]; then
  debug "Conexión SSH exitosa."
else
  debug "Error: Falló la prueba de conexión SSH"
  debug "Salida SSH: $ssh_output"
  exit 1
fi

# Desempaquetar el tarball en PythonAnywhere y recargar la aplicación web
debug "Ejecutando comandos de despliegue en PythonAnywhere..."
ssh_output=$(ssh -vvv -i ~/.ssh/id_rsa -o StrictHostKeyChecking=no -T ${PA_USER}@ssh.pythonanywhere.com << EOF
  set -e
  echo "Conectado a PythonAnywhere"
  if cd /home/${PA_USER}/IsolaMenu; then
    echo "Cambio de directorio exitoso."
  else
    echo "Error: No se pudo cambiar al directorio del proyecto"
    exit 1
  fi

  if tar xzf /home/${PA_USER}/${REPO_NAME}.tar.gz -C /home/${PA_USER}/IsolaMenu; then
    echo "Descompresión del tarball exitosa."
  else
    echo "Error: No se pudo descomprimir el tarball"
    exit 1
  fi

  if rm /home/${PA_USER}/${REPO_NAME}.tar.gz; then
    echo "Eliminación del tarball exitosa."
  else
    echo "Error: No se pudo eliminar el tarball"
    exit 1
  fi

  if source /home/${PA_USER}/.virtualenvs/your_virtualenv/bin/activate; then
    echo "Activación del entorno virtual exitosa."
  else
    echo "Error: No se pudo activar el entorno virtual"
    exit 1
  fi

  if pip install -r /home/${PA_USER}/IsolaMenu/Backend/requirements.txt; then
    echo "Instalación de requerimientos exitosa."
  else
    echo "Error: No se pudieron instalar los requerimientos"
    exit 1
  fi

  if python /home/${PA_USER}/IsolaMenu/Backend/manage.py collectstatic --noinput; then
    echo "Comando collectstatic exitoso."
  else
    echo "Error: Falló collectstatic"
    exit 1
  fi

  if python /home/${PA_USER}/IsolaMenu/Backend/manage.py migrate; then
    echo "Comando migrate exitoso."
  else
    echo "Error: Falló migrate"
    exit 1
  fi

  if pa_reload_webapp your_webapp_name.pythonanywhere.com; then
    echo "Recarga de la aplicación web exitosa."
  else
    echo "Error: Falló pa_reload_webapp"
    exit 1
  fi

  echo "Despliegue completado con éxito"
EOF
)

ssh_exit_code=$?
if [ $ssh_exit_code -eq 0 ]; then
  debug "Despliegue completado con éxito"
else
  debug "Error: Falló la ejecución de comandos en PythonAnywhere"
  debug "Salida SSH: $ssh_output"
  exit 1
fi
