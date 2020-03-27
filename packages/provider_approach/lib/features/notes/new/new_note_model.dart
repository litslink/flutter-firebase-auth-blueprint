import 'package:flutter_firebase_auth_blueprint/features/notes/new/new_note_delegate.dart';
import 'package:flutter_firebase_auth_blueprint/features/util/base_model.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/note.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/notes_repository.dart';

enum ViewState {
  inputForm,
  loading
}

class NewNoteModel extends BaseModel<ViewState> {
  final NotesRepository _notesRepository;
  final AuthRepository _authRepository;
  final NewNoteDelegate _delegate;

  String _title = '';
  String _text = '';

  NewNoteModel(
    this._notesRepository,
    this._authRepository,
    this._delegate);

  @override
  ViewState get initialState => ViewState.inputForm;

  // ignore: use_setters_to_change_properties
  void titleChanged(String title) {
    _title = title;
  }

  // ignore: use_setters_to_change_properties
  void textChanged(String text) {
    _text = text;
  }

  void saveNote() async {
    state = ViewState.loading;
    try {
      final userId = (await _authRepository.getUser()).id;
      final note = Note(null, _title, _text);
      await _notesRepository.add(userId, note);
      _delegate.closeScreen();
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print(e);
      state = ViewState.inputForm;
      _delegate.showError();
    }
  }
}
