"""Views for Hello World"""

from django.http import JsonResponse


def hello_world(request):
    """Returns Hello world Json Response"""

    return JsonResponse(data={'data': 'Hello World'}, safe=False)
