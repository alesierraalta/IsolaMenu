# backend/isolaDjango/middleware.py

import logging
from django.http import JsonResponse

logger = logging.getLogger(__name__)

class CustomErrorMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        return response

    def process_exception(self, request, exception):
        logger.error(f"Error occurred: {exception}", exc_info=True)
        return JsonResponse({'error': str(exception)}, status=400)
