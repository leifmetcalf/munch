from django.conf import settings
from django.contrib.auth.models import AbstractUser
from django.db import models
from django_countries.fields import CountryField


class User(AbstractUser):
    pass


class Gourmand(models.Model):
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="gourmand"
    )
    inviter = models.ForeignKey(
        User, on_delete=models.CASCADE, null=True, related_name="invitees"
    )
    country = CountryField()

    def __str__(self):
        return f"{self.user} {self.country}"


class InviteCode(models.Model):
    code = models.CharField(max_length=100)
    inviter = models.ForeignKey(User, on_delete=models.CASCADE)

    def __str__(self):
        return f"{self.code}"


class Restaurant(models.Model):
    name = models.CharField(max_length=100)
    address = models.CharField(max_length=200)
    google_maps_place_id = models.CharField(max_length=32, null=True)
    note = models.TextField(max_length=1000, blank=True)

    def __str__(self):
        return f"{self.name}"


class List(models.Model):
    author = models.ForeignKey(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=200)
    slug = models.SlugField()

    class Meta:
        unique_together = ["name", "slug"]

    def __str__(self):
        return f"{self.name}"


class ListItem(models.Model):
    parent = models.ForeignKey(List, on_delete=models.CASCADE)
    order = models.PositiveIntegerField()
    restaurant = models.ForeignKey(Restaurant, on_delete=models.CASCADE)
    note = models.TextField(max_length=1000, blank=True)

    def __str__(self):
        return f"{self.restaurant}"
