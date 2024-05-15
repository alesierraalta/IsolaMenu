# menu/admin.py

from django.contrib import admin
from .models import Categoria, Comida

# Personaliza la interfaz de administración para Categoria
class CategoriaAdmin(admin.ModelAdmin):
    list_display = ('ID_categoria', 'Nombre_categoria')
    search_fields = ('Nombre_categoria',)
    fields = ['Nombre_categoria']  # Eliminar 'ID_categoria' de 'fields'

# Personaliza la interfaz de administración para Comida
class ComidaAdmin(admin.ModelAdmin):
    list_display = ('ID_comida', 'Nombre_comida', 'Categoria', 'Precio_comida')
    list_filter = ('Categoria',)
    search_fields = ('Nombre_comida', 'Descripcion_comida')
    fields = ['Nombre_comida', 'Categoria', 'Descripcion_comida', 'Precio_comida']  # Eliminar 'ID_comida' de 'fields'

# Asegúrate de registrar cada modelo solo una vez
admin.site.register(Categoria, CategoriaAdmin)
admin.site.register(Comida, ComidaAdmin)
