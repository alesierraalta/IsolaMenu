from django.db import models
from django.core.exceptions import ValidationError

# Modelo para las categorías del menú
class Categoria(models.Model):
    ID_categoria = models.BigAutoField(primary_key=True)
    Nombre_categoria = models.TextField()

    def __str__(self):
        return self.Nombre_categoria

    class Meta:
        db_table = 'Categorias'
        verbose_name_plural = "Categorias"

# Modelo para los elementos del menú (comidas)
class Comida(models.Model):
    ID_comida = models.BigAutoField(primary_key=True)
    Categoria = models.ForeignKey(Categoria, related_name='comidas', on_delete=models.CASCADE, db_column='ID_categoria')
    Descripcion_comida = models.TextField()
    Nombre_comida = models.CharField(max_length=255)
    Precio_comida = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return self.Nombre_comida

    def clean(self):
        if self.Precio_comida < 0:
            raise ValidationError({'Precio_comida': 'El precio no puede ser negativo.'})

    class Meta:
        db_table = 'Comidas'
        verbose_name_plural = "Comidas"
