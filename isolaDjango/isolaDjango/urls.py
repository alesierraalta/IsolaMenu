from django.contrib import admin
from django.urls import path, include
from django.http import HttpResponse

def home(request):
    # Vista simple para la página de inicio
    return HttpResponse("¡Hola, Django React!")

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', home, name='home'),  # Ruta para la página de inicio
    path('api/menu/', include('menu.urls')),  # Incluye las URLs de la aplicación 'menu'
    path('api/multimedia/', include('multimedia.urls')),  # Incluye las URLs de la aplicación 'multimedia'
    # Añade aquí más rutas según sea necesario
]