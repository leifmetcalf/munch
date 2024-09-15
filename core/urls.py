from django.urls import include, path

from . import views


app_name = 'core'

urlpatterns = [
    path('', views.IndexView.as_view(), name='index'),
    path('restaurants/new/', views.NewRestaurantView.as_view(), name='new_restaurant'),
    path('restaurants/new/done/', views.NewRestaurantDoneView.as_view(), name='new_restaurant_done'),
    path('restaurant/<slug:slug>/', views.RestaurantDetailView.as_view(), name='restaurant_detail'),
    path('lists/', views.ListsView.as_view(), name='lists'),
    path('account/create/', views.NewUserView.as_view(), name='new_user'),
    path('account/create/done/', views.NewUserDoneView.as_view(), name='new_user_done'),
    path('account/', include('django.contrib.auth.urls')),
    path('logs/new/', views.NewLogView.as_view(), name='new_log'),
    path('logs/new/done/', views.NewLogDoneView.as_view(), name='new_log_done'),
    path('lists/new/', views.NewListView.as_view(), name='new_list'),
    path('lists/new/done/', views.NewListDoneView.as_view(), name='new_list_done'),
    path('user/<username>/', views.UserDetailView.as_view(), name='user_detail'),
    path('user/<username>/logs/', views.UserLogsView.as_view(), name='user_logs'),
    path('user/<username>/logs/<int:pk>/', views.LogDetailView.as_view(), name='log_detail'),
    path('user/<username>/logs/<int:pk>/edit/', views.LogEditView.as_view(), name='log_edit'),
    path('user/<username>/reviews/', views.UserReviewsView.as_view(), name='new_review'),
    path('user/<username>/review/<slug:slug>/', views.ReviewDetailView.as_view(), name='review_detail'),
    path('user/<username>/review/<slug:slug>/edit/', views.ReviewEditView.as_view(), name='review_edit'),
    path('user/<username>/lists/', views.UserListsView.as_view(), name='user_lists'),
    path('user/<username>/list/<slug:slug>/', views.ListDetailView.as_view(), name='list_detail'),
    path('user/<username>/list/<slug:slug>/edit/', views.list_edit, name='list_edit'),
]
