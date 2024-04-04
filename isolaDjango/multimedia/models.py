from django.db import models
from menu.models import Comida

# Modelo para los videos asociados a las comidas
class Video(models.Model):
    comida = models.OneToOneField(Comida, related_name='video', on_delete=models.CASCADE)
    url_video = models.URLField(max_length=1024)
    descripcion = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"Video para {self.comida.Nombre_comida}"

    class Meta:
        db_table = 'Videos'
        verbose_name_plural = "Videos"
