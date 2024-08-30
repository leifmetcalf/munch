from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from django.forms import ModelForm
from django.urls import reverse_lazy
from django.views.generic.edit import CreateView

from datetime import date

from .models import Restaurant, Review

def index(request):
    context = {
        'restaurants': Restaurant.objects.order_by('name'),
        'new_reviews': Review.objects.order_by('date'),
    }
    return render(request, 'core/index.html', context)

class LogView(CreateView):
    model = Review
    fields = "__all__"
    success_url = reverse_lazy('core:index')
    def get_initial(self):
        initial = super().get_initial()
        initial['date'] = date.today()
        return initial
