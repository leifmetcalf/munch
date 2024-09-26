from django.conf import settings
from django.contrib.auth import authenticate, login
from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth.decorators import login_required
from django.core.exceptions import ValidationError
from django.forms import (
    BaseInlineFormSet,
    ModelForm,
    inlineformset_factory,
)
from django import forms
from django.shortcuts import render, redirect, get_object_or_404
from django.utils.text import slugify
from django.utils.translation import gettext as _
from django.views.generic.base import TemplateView
from django.views.generic.detail import DetailView
from django.views.generic.list import ListView
from django.db import transaction
from django_countries.fields import CountryField


from .models import User, Restaurant, Gourmand, InviteCode, List, ListItem


class IndexView(TemplateView):
    template_name = "core/index.html"


class UserCreationByInviteForm(UserCreationForm):
    country = CountryField().formfield()
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
            gourmand = Gourmand(
                user=user, inviter=data.inviter, country=self.cleaned_data["country"]
            )
            if commit:
                gourmand.save()
                data.delete()


def register(request):
    if request.method == "POST":
        form = UserCreationByInviteForm(request.POST)
        if form.is_valid():
            new_user = form.save()
            new_user = authenticate(
                username=form.cleaned_data["username"],
                password=form.cleaned_data["password1"],
            )
            login(request, new_user)
            return redirect("core:index")
    else:
        form = UserCreationByInviteForm()
    return render(request, "core/user_creation.html", {"form": form})


class ListsView(ListView):
    model = List


def restaurant_detail(request, pk):
    restaurant = get_object_or_404(Restaurant, pk=pk)
    lists = List.objects.filter(listitem__restaurant=restaurant).distinct()
    context = {
        "object": restaurant,
        "lists": lists,
    }
    return render(request, "core/restaurant_detail.html", context)


def restaurants(request):
    restaurants = Restaurant.objects.all()
    return render(request, "core/restaurants.html", {"restaurants": restaurants})


def restaurant_new(request):
    if request.method == "POST":
        form = RestaurantForm(request.POST)
        if form.is_valid():
            restaurant = form.save()
            return redirect("core:restaurant_detail", pk=restaurant.pk)
    else:
        form = RestaurantForm()

    return render(
        request,
        "core/restaurant_new.html",
        {
            "form": form,
            "google_maps_api_key": settings.GOOGLE_MAPS_API_KEY,
        },
    )


class RestaurantForm(forms.ModelForm):
    class Meta:
        model = Restaurant
        fields = ["name", "address", "google_maps_place_id", "note"]


class NewRestaurantDoneView(TemplateView):
    pass


class ListDetailView(DetailView):
    model = List

    def get_queryset(self):
        return self.model.objects.filter(author__username=self.kwargs.get("username"))


class ListForm(ModelForm):
    class Meta:
        model = List
        fields = ["name"]

    def save(self, commit=True):
        self.instance.slug = slugify(self.instance.name)
        return super().save(commit)


class ListItemForm(ModelForm):
    class Meta:
        model = ListItem
        fields = ["restaurant", "note"]

    def save(self, commit=True):
        self.instance.order = self.cleaned_data["ORDER"]
        return super().save(commit)


class ListItemBaseFormSet(BaseInlineFormSet):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.queryset = self.queryset.order_by("order")


@login_required
def list_edit(request, username=None, slug=None):
    user = (
        request.user if username is None else get_object_or_404(User, username=username)
    )
    if request.user != user:
        return redirect(f"{settings.LOGIN_URL}?next={request.path}")
    list_ = None if slug is None else get_object_or_404(List, author=user, slug=slug)
    ListItemFormSet = inlineformset_factory(
        List,
        ListItem,
        form=ListItemForm,
        formset=ListItemBaseFormSet,
        can_order=True,
        can_delete=True,
        extra=0,
    )
    if request.method == "POST":
        form = ListForm(request.POST, instance=list_)
        formset = ListItemFormSet(request.POST, instance=form.instance)
        if form.is_valid() and formset.is_valid():
            # If the list is new, set the form's author to the current user
            if list_ is None:
                form.instance.author = request.user
            with transaction.atomic():
                form.save()
                formset.save()
            return redirect(
                "core:list_detail", form.instance.author.username, form.instance.slug
            )
    else:
        form = ListForm(instance=list_)
        formset = ListItemFormSet(instance=form.instance)
    context = {"form": form, "formset": formset}
    return render(request, "core/list_edit.html", context)


class UserDetailView(DetailView):
    model = Gourmand
    slug_field = "user__username"
    slug_url_kwarg = "username"
