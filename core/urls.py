from django.urls import path

from . import views


app_name = 'core'

urlpatterns = [
    path('', views.index, name='index'),
    path('log/', views.LogView.as_view(), name='log'),
]
