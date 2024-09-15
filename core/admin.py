from django.contrib import admin

from .models import Review, Restaurant, Log, Gourmand, User, InviteCode, List, ListItem

admin.site.register([User, Gourmand, Review, Restaurant, Log, InviteCode, List, ListItem])
