from django.shortcuts import render
from django.http import HttpResponse

from .models import Restaurant, Review

def index(request):
    context = {
        'restaurants': Restaurant.objects.order_by('name'),
        'new_reviews': Review.objects.order_by('publish_time'),
    }
    return render(request, 'core/index.html', context)

def log(request):
    context = {}
    return render(request, 'core/log.html', context)
