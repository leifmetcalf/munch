from django.db import models
from django.contrib.auth.models import User

class Gourmand(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    inviter = models.ForeignKey('self', on_delete=models.CASCADE)
    def __str__(self):
        return f'{self.user}'

class InviteCode(models.Model):
    code = models.CharField(max_length=100)
    inviter = models.ForeignKey(Gourmand, on_delete=models.CASCADE)
    def __str__(self):
        return f'{self.code}'

class Restaurant(models.Model):
    name = models.CharField(max_length=100)
    link_google_maps = models.IntegerField(null=True)
    notes = models.CharField(max_length=1000, blank=True)
    def __str__(self):
        return f'{self.name}'

class Review(models.Model):
    user = models.ForeignKey(Gourmand, on_delete=models.CASCADE)
    restaurant = models.ForeignKey(Restaurant, on_delete=models.CASCADE)
    text = models.TextField("review text", max_length=1000)
    favourite = models.BooleanField()
    def __str__(self):
        return f'{self.restaurant} {self.text} {self.date} {self.favourite}'

class Log(models.Model):
    user = models.ForeignKey(Gourmand, on_delete=models.CASCADE)
    restaurant = models.ForeignKey(Restaurant, on_delete=models.CASCADE)
    text = models.TextField("log text", max_length=1000)
    date = models.DateField("date of meal")
    def __str__(self):
        return f'{self.restaurant} {self.date} {self.text}'

