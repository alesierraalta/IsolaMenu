# Utilizamos una imagen oficial de Python que incluye todas las herramientas necesarias para Django
FROM python:3.10-slim as builder

# Establecemos el directorio de trabajo en el contenedor
WORKDIR /app

# Copiamos los archivos de requerimientos primero para aprovechar la cache de Docker
COPY Backend/requirements.txt .

# Instalamos las dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiamos el resto del código del backend al contenedor
COPY Backend/ .

# Utilizamos una imagen oficial de Node.js para construir el frontend de React
FROM node:16-alpine as frontend

# Establecemos el directorio de trabajo para el frontend
WORKDIR /app

# Copiamos los archivos necesarios para las dependencias de Node.js
COPY isola-react/package.json isola-react/package-lock.json ./

# Instalamos las dependencias de Node.js
RUN npm ci

# Copiamos el resto de los archivos del frontend y construimos el proyecto
COPY isola-react/ .
RUN npm run build

# Imagen final para ejecución
FROM python:3.10-slim

# Copiamos el backend del builder
COPY --from=builder /app /app

# Copiamos el build del frontend en la carpeta de estáticos de Django
COPY --from=frontend /app/build /app/isolaDjango/static

# Establecemos variables de entorno
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Exponemos el puerto en el que Django se ejecutará
EXPOSE 8000

# Comando para ejecutar el servidor de Django
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
