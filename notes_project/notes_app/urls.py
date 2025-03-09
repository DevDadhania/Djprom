from django.urls import path
from . import views

urlpatterns = [
    path('', views.notes_view, name='notes'),
    path('delete/', views.delete_note_view, name='delete_note'),
    path('dashboard/', views.dashboard_view, name='dashboard'),
]
