import 'package:flutter_firebase_auth_blueprint_common/data/model/note.dart';

abstract class NotesEvent {}

class NewNote extends NotesEvent {
  final Note note;

  NewNote(this.note);
}

class DeleteNote extends NotesEvent {
  final Note note;

  DeleteNote(this.note);
}

class NotesChanged extends NotesEvent {
  final List<Note> notes;

  NotesChanged(this.notes);
}

class NotesFetchingThrowError extends NotesEvent {}
