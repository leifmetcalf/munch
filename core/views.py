from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from django.forms import ModelForm
from django.urls import reverse_lazy
from django.views.generic.edit import CreateView, FormView
from django.views.generic.base import TemplateView
from django.contrib.auth.models import User
from django.contrib.auth.forms import BaseUserCreationForm
from django import forms

from datetime import date

from .models import Restaurant, Review, Log, Gourmand, InviteCode

def index(request):
    context = {
    }
    return render(request, 'core/index.html', context)

class LogView(CreateView):
    model = Log
    fields = "__all__"
    success_url = reverse_lazy('core:log_success')
    def get_initial(self):
        initial = super().get_initial()
        initial['date'] = date.today()
        return initial

class LogSuccessView(TemplateView):
    pass

class UserCreationByInviteForm(BaseUserCreationForm):
    invite_code = forms.CharField()
    def clean_invite_code(self):
        code = self.cleaned_data['invite_code']
        try:
            return InviteCode.objects.get(code=code)
        except InviteCode.DoesNotExist:
            raise ValidationError(
                _("Invalid invite code: %(code)s"),
                code="invalid",
                params={'code': code}
            )
    def save(self, commit=True):
        with transaction.atomic():
            user = super().save(commit)
            data = self.cleaned_data['invite_code']
            gourmand = Gourmand(user=user, inviter=data.inviter)
            if commit:
                gourmand.save()

class UserCreationView(FormView):
    template_name = "core/user_creation.html"
    form_class = UserCreationByInviteForm
    success_url = reverse_lazy('core:user_creation_success')

class UserCreationSuccessView(TemplateView):
    pass
