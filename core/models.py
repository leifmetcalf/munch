from django.conf import settings
from django.db import models
from django.contrib.auth.models import AbstractUser

class User(AbstractUser):
    pass

class Gourmand(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='gourmand')
    inviter = models.ForeignKey(User, on_delete=models.CASCADE, null=True, related_name='invitees')
    def __str__(self):
        return f'{self.user}'

class InviteCode(models.Model):
    code = models.CharField(max_length=100)
    inviter = models.ForeignKey(User, on_delete=models.CASCADE)
    def __str__(self):
        return f'{self.code}'

class Restaurant(models.Model):
    name = models.CharField(max_length=100)
    slug = models.SlugField()
    link_google_maps = models.URLField(null=True)
    notes = models.TextField(max_length=1000, blank=True)
    def __str__(self):
        return f'{self.name}'

class Review(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    restaurant = models.ForeignKey(Restaurant, on_delete=models.CASCADE)
    text = models.TextField(max_length=1000, blank=True)
    favourite = models.BooleanField()
    def __str__(self):
        return f'{self.restaurant} {self.text} {self.favourite}'

class Log(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    restaurant = models.ForeignKey(Restaurant, on_delete=models.CASCADE)
    date = models.DateField()
    notes = models.TextField(max_length=1000)
    def __str__(self):
        return f'{self.restaurant} {self.date} {self.notes}'

class List(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=200)
    slug = models.SlugField()
    def __str__(self):
        return f'{self.name}'

class RestaurantItem(models.Model):
    parent = models.ForeignKey(List, on_delete=models.CASCADE)
    restaurant = models.ForeignKey(Restaurant, on_delete=models.CASCADE)
    note = models.TextField(max_length=1000)

class TextItem(models.Model):
    text = models.TextField(max_length=1000)
