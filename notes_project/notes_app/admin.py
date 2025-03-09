from django.contrib import admin
from .models import Note

admin.site.register(Note)
# The code above registers the Note model with the Django admin site. This allows us to manage the Note model from the Django admin interface.