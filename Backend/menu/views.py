from rest_framework import viewsets
from .models import Categoria, Comida
from .serializers import CategoriaSerializer, ComidaSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from django.http import JsonResponse

def example_view(request):
    if request.method == 'GET':
        return JsonResponse({'message': 'Hello, world!'})
    else:
        return JsonResponse({'error': 'Invalid request'}, status=400)

class CategoriaViewSet(viewsets.ModelViewSet):
    queryset = Categoria.objects.all()
    serializer_class = CategoriaSerializer

class ComidaViewSet(viewsets.ModelViewSet):
    queryset = Comida.objects.all()
    serializer_class = ComidaSerializer

class ComidaPorCategoria(APIView):
    def get(self, request, categoria_id):
        comidas = Comida.objects.filter(Categoria__ID_categoria=categoria_id)
        serializer = ComidaSerializer(comidas, many=True)
        return Response(serializer.data)