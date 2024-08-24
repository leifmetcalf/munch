from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from django.forms import ModelForm
from django.urls import reverse

from datetime import date

from .models import Restaurant, Review

def index(request):
    log_form = LogForm(initial={'date': date.today()})
    context = {
        'restaurants': Restaurant.objects.order_by('name'),
        'new_reviews': Review.objects.order_by('date'),
        'form': log_form
    }
    return render(request, 'core/index.html', context)

class LogForm(ModelForm):
    class Meta:
        model = Review
        fields = "__all__"

def log(request):
    if request.method == "POST":
        form = LogForm(request.POST)
        if form.is_valid():
            form.save()
            return HttpResponseRedirect(reverse('core:index'))
