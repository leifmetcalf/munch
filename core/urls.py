from django.urls import include, path

from . import views


app_name = 'core'

urlpatterns = [
    path('', views.index, name='index'),
    path('log/', views.LogView.as_view(), name='log'),
    path('log_success/', views.LogSuccessView.as_view(), name='log_success'),
    path('accounts/create/', views.UserCreationView.as_view(), name='user_creation'),
    path('accounts/create/done/', views.UserCreationSuccessView.as_view(), name='user_creation_success'),
    path('accounts/', include('django.contrib.auth.urls')),
]
