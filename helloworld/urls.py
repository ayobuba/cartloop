"""URLs for Hello World API"""

from django.urls import path
from . import views as hello_world_views

app_name = 'helloworld'

urlpatterns = [
    path('hello_world/', hello_world_views.hello_world, name='hello_world'),
]
