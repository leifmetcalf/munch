from django.contrib import admin

# Register your models here.
from .models import Review, Restaurant

admin.site.register([Review, Restaurant])
