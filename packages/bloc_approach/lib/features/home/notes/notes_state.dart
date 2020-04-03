import 'package:flutter_firebase_auth_blueprint_common/data/model/note.dart';

abstract class NotesState {}

class Loading extends NotesState {}

class Empty extends NotesState {}

class Error extends NotesState {}

class Content extends NotesState {
  final List<Note> notes;

  Content(this.notes);
}
