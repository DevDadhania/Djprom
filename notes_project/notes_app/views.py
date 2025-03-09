from django.shortcuts import render, redirect
from .models import Note
from .forms import NoteForm

def notes_view(request):
    if request.method == 'POST':
        form = NoteForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('notes')
    else:
        form = NoteForm()
    return render(request, 'notes_app/notes.html', {'form': form})

def delete_note_view(request):
    if request.method == 'POST':
        note_id = request.POST.get('note_id')
        try:
            note = Note.objects.get(id=note_id)
            note.delete()
        except Note.DoesNotExist:
            pass
        return redirect('notes')

def dashboard_view(request):
    notes = Note.objects.all()
    return render(request, 'notes_app/dashboard.html', {'notes': notes})
