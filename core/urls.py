from django.urls import include, path

from . import views


app_name = "core"

urlpatterns = [
    path("", views.IndexView.as_view(), name="index"),
    path("account/create/", views.register, name="user_new"),
    path("account/", include("django.contrib.auth.urls")),
    path("restaurants/", views.restaurants, name="restaurants"),
    path("restaurants/new/", views.restaurant_new, name="restaurant_new"),
    path("restaurant/<int:pk>/", views.restaurant_detail, name="restaurant_detail"),
    path("lists/", views.ListsView.as_view(), name="lists"),
    path("lists/new/", views.list_edit, name="list_new"),
    path("user/<username>/", views.UserDetailView.as_view(), name="user_detail"),
    path(
        "user/<username>/list/<slug:slug>/",
        views.ListDetailView.as_view(),
        name="list_detail",
    ),
    path("user/<username>/list/<slug:slug>/edit/", views.list_edit, name="list_edit"),
]
