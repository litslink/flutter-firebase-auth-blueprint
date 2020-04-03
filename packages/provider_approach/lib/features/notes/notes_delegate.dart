import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/new_note_widget.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/note.dart';

// ignore: one_member_abstracts
abstract class NotesDelegate {

  Future<Note> navigateToNewNote();
}

class NotesDelegateImpl extends NotesDelegate {
  final BuildContext context;

  NotesDelegateImpl(this.context);

  @override
  Future<Note> navigateToNewNote() async {
    final note = await Navigator.of(context).pushNamed(NewNoteWidget.route) as Note;
    return note;
  }
}
