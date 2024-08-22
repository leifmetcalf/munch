from django.db import models

class Restaurant(models.Model):
    name = models.CharField(max_length=100)
    coords = models.IntegerField(null=True)
    notes = models.CharField(max_length=1000, blank=True)
    def __str__(self):
        return f'{self.name} {self.coords} {self.notes}'

class Review(models.Model):
    text = models.CharField(max_length=1000)
    rating = models.IntegerField()
    publish_time = models.DateTimeField('date published')
    restaurant = models.ForeignKey(Restaurant, on_delete=models.CASCADE)
    def __str__(self):
        return f'{self.text} {self.rating} {self.publish_time} {self.restaurant}'
