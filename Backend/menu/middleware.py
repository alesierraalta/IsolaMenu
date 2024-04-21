from django.utils.deprecation import MiddlewareMixin
from prometheus_client import Counter

ACTIVE_USERS = Counter('active_users', 'Number of active user requests')

class ActiveUserMiddleware(MiddlewareMixin):
    def process_request(self, request):
        # Incrementa el contador cada vez que se procesa una solicitud
        ACTIVE_USERS.inc()
