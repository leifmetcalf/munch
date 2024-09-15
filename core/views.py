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
from django.views.generic.edit import CreateView, FormView
from django.views.generic.list import ListView
from django.db import transaction

from datetime import date

from .models import User, Restaurant, Review, Log, Gourmand, InviteCode, List, ListItem


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


class NewListView(LoginRequiredMixin, CreateView):
    model = List
    fields = ["name"]

    def form_valid(self, form):
        obj = form.save(commit=False)
        obj.user = self.request.user
        obj.slug = slugify(obj.name)
        return super().form_valid(form)

    success_url = reverse_lazy("core:new_list_done")


class NewListDoneView(TemplateView):
    template_name = "core/new_list_done.html"


class LogEditView(FormView):
    pass


class ListItemForm(ModelForm):
    class Meta:
        model = ListItem
        fields = ["item_type", "restaurant_restaurant", "restaurant_note", "text_text"]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields["restaurant_restaurant"].required = False
        self.fields["restaurant_note"].required = False
        self.fields["text_text"].required = False
        print("hi")

    def clean(self):
        cleaned_data = super().clean()
        item_type = cleaned_data.get("item_type")
        if item_type == "restaurant":
            if not cleaned_data.get("restaurant_restaurant"):
                self.add_error("restaurant_restaurant", "Please enter a restaurant.")
        return cleaned_data


def list_edit_item_partial(request, username, slug):
    list_ = List.objects.get(user__username=username, slug=slug)
    ListItemFormSet = inlineformset_factory(
        List,
        ListItem,
        form=ListItemForm,
        fields=["item_type", "restaurant_restaurant", "restaurant_note", "text_text"],
        can_delete=True,
        can_order=True,
        extra=1,
        max_num=1,
    )


def list_edit(request, username, slug):
    list_ = List.objects.get(user__username=username, slug=slug)
    ListItemFormSet = inlineformset_factory(
        List,
        ListItem,
        form=ListItemForm,
        fields=["item_type", "restaurant_restaurant", "restaurant_note", "text_text"],
        can_delete=True,
        can_order=True,
        extra=1,
        max_num=1,
    )
    if request.method == "POST":
        formset = ListItemFormSet(request.POST, instance=list_)
        if formset.is_valid():
            formset.save()
            return HttpResponseRedirect(
                reverse("core:list_edit", args=[username, slug])
            )
    else:
        formset = ListItemFormSet(instance=list_)
    return render(request, "core/list_edit.html", {"formset": formset})


class ReviewEditView(FormView):
    pass


class UserDetailView(DetailView):
    pass
