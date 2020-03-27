import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/new/new_note_widget.dart';

abstract class NotesDelegate {

  void navigateToNewNote();

  void showFetchError();
}

class NotesDelegateImpl extends NotesDelegate {
  final BuildContext context;

  NotesDelegateImpl(this.context);

  @override
  void navigateToNewNote() => Navigator.of(context).pushNamed(NewNoteWidget.route);

  @override
  void showFetchError() {

  }
}
