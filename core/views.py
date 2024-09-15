from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.mixins import LoginRequiredMixin
from django.core.exceptions import ValidationError
from django.forms import ModelForm, inlineformset_factory, Form
from django.http import HttpResponse, HttpResponseRedirect
from django import forms
from django.shortcuts import render
from django.utils.text import slugify
from django.urls import reverse_lazy, reverse
from django.utils.translation import gettext as _
from django.views.generic.base import TemplateView
from django.views.generic.detail import DetailView
from django.views.generic.edit import CreateView, FormView, UpdateView
from django.views.generic.list import ListView
from django.db import transaction

from datetime import date

from .models import (
    User,
    Restaurant,
    Review,
    Log,
    Gourmand,
    InviteCode,
    List,
    RestaurantItem,
    TextItem,
)


class IndexView(TemplateView):
    template_name = "core/index.html"


class NewLogView(LoginRequiredMixin, CreateView):
    model = Log
    fields = ["restaurant", "date", "notes"]
    success_url = reverse_lazy("core:new_log_done")

    def get_initial(self):
        initial = super().get_initial()
        initial["user"] = self.request.user
        initial["date"] = date.today()
        return initial


class NewLogDoneView(TemplateView):
    template_name = "core/log_done.html"


class UserCreationByInviteForm(UserCreationForm):
    invite_code = forms.CharField()

    class Meta(UserCreationForm.Meta):
        model = User

    def clean_invite_code(self):
        code = self.cleaned_data["invite_code"]
        try:
            return InviteCode.objects.get(code=code)
        except InviteCode.DoesNotExist:
            raise ValidationError(
                _("Invalid invite code: %(code)s"),
                code="invalid",
                params={"code": code},
            )

    def save(self, commit=True):
        with transaction.atomic():
            user = super().save(commit)
            data = self.cleaned_data["invite_code"]
            gourmand = Gourmand(user=user, inviter=data.inviter)
            if commit:
                gourmand.save()
                data.delete()


class NewUserView(FormView):
    template_name = "core/user_creation.html"
    form_class = UserCreationByInviteForm
    success_url = reverse_lazy("core:new_user_done")

    def form_valid(self, form):
        form.save()
        return super().form_valid(form)


class NewUserDoneView(TemplateView):
    template_name = "core/user_creation_done.html"


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

    def get_queryset(self):
        return self.model.objects.filter(user__username=self.kwargs.get("username"))


class NewListDoneView(TemplateView):
    template_name = "core/new_list_done.html"


class LogEditView(FormView):
    pass


class NewTextItemView(CreateView):
    model = TextItem
    fields = ["text"]

    def form_valid(self, form):
        try:
            list_ = List.objects.get(
                user__username=self.kwargs.get("username"), slug=self.kwargs.get("slug")
            )
            form.instance.parent = list_
            return super().form_valid(form)
        except List.DoesNotExist:
            pass


class HtmxRestaurantItemView(UpdateView):
    model = RestaurantItem
    fields = ["restaurant", "note"]
    template_name = "core/htmx_restaurant_item.html"

    def get_object(self, queryset=None):
        try:
            return super().get_object(queryset)
        except AttributeError:
            pass

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        try:
            context["path"] = reverse(
                "core:htmx_update_restaurant_item", args=[self.object.parent.pk]
            )
        except AttributeError:
            context["path"] = reverse("core:htmx_new_restaurant_item")
        return context

    def form_valid(self, form):
        try:
            list_ = List.objects.get(pk=self.kwargs.get("pk"))
            form.instance.parent = list_
            return super().form_valid(form)
        except List.DoesNotExist:
            return self.form_invalid(form)


class ListEditView(UpdateView):
    model = List
    fields = ["name"]
    template_name = "core/list_edit.html"

    def get_queryset(self):
        return self.model.objects.filter(user__username=self.kwargs.get("username"))

    def get_object(self, queryset=None):
        try:
            return super().get_object(queryset)
        except AttributeError:
            pass

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        try:
            context["item_paths"] = [
                reverse("core:htmx_update_restaurant_item", args=[pk])
                for pk in RestaurantItem.objects.filter(parent=self.object).values_list(
                    "pk", flat=True
                )
            ]
        except AttributeError:
            pass
        return context

    def form_valid(self, form):
        form.instance.user = self.request.user
        form.instance.slug = slugify(form.instance.name)
        return super().form_valid(form)

    def get_success_url(self):
        return reverse(
            "core:list_detail",
            args=[self.request.user.get_username(), self.object.slug],
        )


class ReviewEditView(FormView):
    pass


class UserDetailView(DetailView):
    pass
