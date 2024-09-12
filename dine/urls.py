from django.contrib import admin
from django.urls import include, path

import core.views

urlpatterns = [
    path('', include('core.urls')),
    path('admin/', admin.site.urls),
]
