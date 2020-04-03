import 'dart:async';

import 'package:flutter_firebase_auth_blueprint/features/util/base_model.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/note.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/notes_repository.dart';

import 'notes_delegate.dart';

abstract class ViewState {}

class Content extends ViewState {
  final List<Note> notes;

  Content(this.notes);
}

class Loading extends ViewState {}

class Empty extends ViewState {}

class Error extends ViewState {}


class NotesModel extends BaseModel<ViewState> {
  final NotesRepository _notesRepository;
  final AuthRepository _authRepository;
  final NotesDelegate _delegate;

  StreamSubscription _notesSubscription;

  NotesModel(
    this._notesRepository,
    this._authRepository,
    this._delegate) {
    _observeNotes();
  }

  @override
  ViewState get initialState => Loading();

  @override
  void dispose() {
    _notesSubscription?.cancel();
    super.dispose();
  }

  void addNote() async {
    final note = await _delegate.navigateToNewNote();
    if (note != null) {
      final userId = (await _authRepository.getUser()).id;
      await _notesRepository.add(userId, note);
    }
  }

  void deleteNote(Note note) async {
    final userId = (await _authRepository.getUser()).id;
    await _notesRepository.delete(userId, note);
  }

  void _observeNotes() async {
    final userId = (await _authRepository.getUser()).id;
    _notesSubscription = _notesRepository.get(userId).listen(
      _onNotesChanged,
      onError: (Object error) {
        state = Error();
      }
    );
  }

  void _onNotesChanged(List<Note> notes) {
    if (notes.isEmpty) {
      state = Empty();
    } else {
      state = Content(notes);
    }
  }
}