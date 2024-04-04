from django.test import TestCase
from django.core.exceptions import ValidationError
from .models import Categoria, Comida

class CategoriaModelTest(TestCase):

    def test_creacion_categoria(self):
        """ Prueba la creación de una categoría con un nombre válido. """
        categoria = Categoria.objects.create(Nombre_categoria='Entrantes')
        self.assertEqual(categoria.Nombre_categoria, 'Entrantes')

    def test_categoria_str(self):
        """ Prueba que el método __str__ de Categoria devuelve el nombre de la categoría. """
        categoria = Categoria(Nombre_categoria='Postres')
        self.assertEqual(str(categoria), 'Postres')

class ComidaModelTest(TestCase):

    def setUp(self):
        """ Crea una instancia de Categoria para ser usada en las pruebas de Comida. """
        self.categoria = Categoria.objects.create(Nombre_categoria='Entrantes')

    def test_creacion_comida_con_precio_positivo(self):
        """ Prueba la creación de un objeto Comida con un precio positivo. """
        comida = Comida.objects.create(
            Categoria=self.categoria,
            Nombre_comida='Ensalada César',
            Descripcion_comida='Lechuga, crutones y parmesano',
            Precio_comida=9.99
        )
        self.assertEqual(comida.Precio_comida, 9.99)

    def test_comida_str(self):
        """ Prueba que el método __str__ de Comida devuelve el nombre de la comida. """
        comida = Comida(
            Categoria=self.categoria,
            Nombre_comida='Pizza Margarita',
            Descripcion_comida='Tomate, mozzarella y albahaca',
            Precio_comida=12.50
        )
        self.assertEqual(str(comida), 'Pizza Margarita')

    def test_validacion_precio_negativo(self):
        """ Prueba que se lanza ValidationError para precios negativos. """
        comida = Comida(
            Categoria=self.categoria,
            Nombre_comida='Sopa Negativa',
            Descripcion_comida='Una sopa con precio negativo',
            Precio_comida=-1.00
        )
        with self.assertRaises(ValidationError):
            comida.full_clean()
