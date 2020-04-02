import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/new/new_note_widget.dart';

// ignore: one_member_abstracts
abstract class NotesDelegate {

  void navigateToNewNote();
}

class NotesDelegateImpl extends NotesDelegate {
  final BuildContext context;

  NotesDelegateImpl(this.context);

  @override
  void navigateToNewNote() => Navigator.of(context).pushNamed(NewNoteWidget.route);
}
