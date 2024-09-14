from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.mixins import LoginRequiredMixin
from django.core.exceptions import ValidationError
from django.forms import ModelForm
from django.http import HttpResponse, HttpResponseRedirect
from django import forms
from django.shortcuts import render
from django.utils.text import slugify
from django.urls import reverse_lazy
from django.utils.translation import gettext as _
from django.views.generic.base import TemplateView
from django.views.generic.detail import DetailView
from django.views.generic.edit import CreateView, FormView
from django.views.generic.list import ListView
from django.db import transaction

from datetime import date

from .models import User, Restaurant, Review, Log, Gourmand, InviteCode, List, RestaurantItem, TextItem

class IndexView(TemplateView):
    template_name = 'core/index.html'

class NewLogView(LoginRequiredMixin, CreateView):
    model = Log
    fields = ['restaurant', 'date', 'notes']
    success_url = reverse_lazy('core:new_log_done')
    def get_initial(self):
        initial = super().get_initial()
        initial['user'] = self.request.user
        initial['date'] = date.today()
        return initial

class NewLogDoneView(TemplateView):
    template_name = 'core/log_done.html'

class UserCreationByInviteForm(UserCreationForm):
    invite_code = forms.CharField()
    class Meta(UserCreationForm.Meta):
        model = User
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
                data.delete()

class NewUserView(FormView):
    template_name = "core/user_creation.html"
    form_class = UserCreationByInviteForm
    success_url = reverse_lazy('core:new_user_done')
    def form_valid(self, form):
        form.save()
        return super().form_valid(form)

class NewUserDoneView(TemplateView):
    template_name = 'core/user_creation_done.html'

class ListsView(ListView):
    model = List

class UserReviewsView(ListView):
    model = Review

class ReviewDetailView(DetailView):
    model = Review

class NewReviewView(CreateView):
    model = Review

class NewReviewDoneView(TemplateView):
    pass

class RestaurantDetailView(DetailView):
    model = Restaurant

class NewRestaurantView(CreateView):
    pass

class NewRestaurantDoneView(TemplateView):
    pass

class UserLogsView(ListView):
    pass

class UserListsView(ListView):
    pass

class LogDetailView(DetailView):
    model = Log

class ListDetailView(DetailView):
    model = List

class NewListView(LoginRequiredMixin, CreateView):
    model = List
    fields = ['name']
    def form_valid(self, form):
        obj = form.save(commit=False)
        obj.user = self.request.user
        obj.slug = slugify(obj.name)
        return super().form_valid(form)
    success_url = reverse_lazy('core:new_list_done')

class NewListDoneView(TemplateView):
    template_name = 'core/new_list_done.html'

class LogEditView(FormView):
    pass

class ListEditView(FormView):
    pass

class ReviewEditView(FormView):
    pass

class NewRestaurantItemView(CreateView):
    model = RestaurantItem

class NewRestaurantItemDoneView(TemplateView):
    pass

class NewTextItemView(CreateView):
    model = TextItem

class NewTextItemDoneView(TemplateView):
    pass

class UserDetailView(DetailView):
    pass
