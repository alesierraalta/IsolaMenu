from pathlib import Path
from dotenv import load_dotenv
import os

# Cargar variables de entorno desde el archivo .env
load_dotenv()

# Construir rutas dentro del proyecto como este: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

# Clave secreta para producción
SECRET_KEY = os.getenv('DJANGO_SECRET_KEY')

# No ejecutar con debug activado en producción
DEBUG = True

# Configuración de hosts permitidos
ALLOWED_HOSTS = [
    'backend-668318878', 
    '45eba246-693a-499c-a4bb-65061d9662be-dev.e1-us-east-azure.choreoapis.dev',
    'localhost', 
    '127.0.0.1'
]

# Definición de aplicaciones instaladas
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'menu',
    'multimedia',
    'usuarios',
    'corsheaders',
]

# Definición de middleware
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'isolaDjango.middleware.CustomErrorMiddleware',
]

# Configuración de URLs
ROOT_URLCONF = 'isolaDjango.urls'

# Configuración de plantillas
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

# Configuración de WSGI
WSGI_APPLICATION = 'isolaDjango.wsgi.application'

# Configuración de base de datos
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('POSTGRES_DATABASE'),
        'USER': os.getenv('POSTGRES_USER'),
        'PASSWORD': os.getenv('POSTGRES_PASSWORD'),
        'HOST': os.getenv('POSTGRES_HOST'),
        'PORT': os.getenv('POSTGRES_PORT'),
        'TEST': {
            'NAME': os.getenv('POSTGRES_TEST_DATABASE', 'test_defaultdb'),
            'SERIALIZE': False,
            'MIRROR': 'default',
        },
    }
}

# Validación de contraseñas
AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator'},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]

# Internacionalización
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

# Archivos estáticos
STATIC_URL = '/static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

# Definición del campo clave primaria por defecto
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# Configuración de CORS
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3001",
    "https://45eba246-693a-499c-a4bb-65061d9662be-dev.e1-us-east-azure.choreoapis.dev"
]

LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'console': {
            'class': 'logging.StreamHandler',
        },
    },
    'root': {
        'handlers': ['console'],
        'level': 'DEBUG',  # Cambia a 'DEBUG' para obtener más detalles
    },
}
