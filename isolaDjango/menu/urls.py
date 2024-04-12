from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import CategoriaViewSet, ComidaViewSet, ComidaPorCategoria

router = DefaultRouter()
router.register(r'categorias', CategoriaViewSet)
router.register(r'comidas', ComidaViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('comidas/categoria/<int:categoria_id>/', ComidaPorCategoria.as_view()),
]
