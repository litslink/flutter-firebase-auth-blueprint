import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint/data/util/validation/validation_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/new/new_note_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/new/new_note_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/note.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/notes_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validation_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validators.dart';

class NewNoteBloc extends Bloc<NewNoteEvent, NewNoteState> {
  
  final AuthRepository _authRepository;
  final NotesRepository _notesRepository;

  final _title = ValidationBloc(NotEmptyValidator());
  final _text = ValidationBloc(NotEmptyValidator());

  NewNoteBloc(this._authRepository, this._notesRepository);

  @override
  NewNoteState get initialState => InputForm(true, true);

  @override
  Stream<NewNoteState> mapEventToState(NewNoteEvent event) async* {
    switch (event.runtimeType) {
      case TitleChanged:
        final title = (event as TitleChanged).title;
        _title.add(title);
        yield InputForm(true, true);
        break;
      case TextChanged:
        final text = (event as TextChanged).text;
        _text.add(text);
        yield InputForm(true, true);
        break;
      case SaveNote:
        try {
          if (_title.state is Valid && _text.state is Valid) {
            yield Loading();
            final userId = (await _authRepository.getUser()).id;
            final note = Note(
              null,
              (_title.state as Valid).text,
              (_text.state as Valid).text
            );
            await _notesRepository.add(userId, note);
            yield NotesRedirect();
          } else {
            yield InputForm(
              _title.state is Valid,
              _text.state is Valid
            );
          }
        // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          yield Error();
        }
    }
  }

  @override
  Future<void> close() {
    _title.close();
    _text.close();
    return super.close();
  }
}
