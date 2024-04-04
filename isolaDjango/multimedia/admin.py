from django.contrib import admin
from .models import Video


# Personalización de la interfaz de administración
class VideoAdmin(admin.ModelAdmin):
    list_display = ('id', 'comida', 'url_video')
    list_select_related = ('comida',)
    search_fields = ('comida__Nombre_comida', 'descripcion')

# Registro con personalización
admin.site.register(Video, VideoAdmin)
