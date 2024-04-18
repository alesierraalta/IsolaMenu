# menu/admin.py

from django.contrib import admin
from .models import Categoria, Comida

# Si deseas personalizar la interfaz de administración para Categoria, puedes hacerlo así:
class CategoriaAdmin(admin.ModelAdmin):
    list_display = ('ID_categoria', 'Nombre_categoria')
    search_fields = ('Nombre_categoria',)
    fields = ['ID_categoria', 'Nombre_categoria']

# Y para Comida:
class ComidaAdmin(admin.ModelAdmin):
    list_display = ('ID_comida', 'Nombre_comida', 'Categoria', 'Precio_comida')
    list_filter = ('Categoria',)
    search_fields = ('Nombre_comida', 'Descripcion_comida')
    fields = ['ID_comida', 'Nombre_comida', 'Categoria', 'Descripcion_comida', 'Precio_comida']  # Haz 'ID_comida' editable

# Asegúrate de registrar cada modelo solo una vez
admin.site.register(Categoria, CategoriaAdmin)
admin.site.register(Comida, ComidaAdmin)
