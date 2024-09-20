from django.contrib import admin

from .models import Restaurant, Gourmand, User, InviteCode, List, ListItem

admin.site.register([User, Gourmand, Restaurant, InviteCode, List, ListItem])
