import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/notes_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/notes_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/notes_repository.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository _notesRepository;
  final AuthRepository _authRepository;

  StreamSubscription _notesSubscription;

  NotesBloc(
    this._notesRepository,
    this._authRepository) {
    _observeNotes();
  }

  @override
  NotesState get initialState => Loading();

  @override
  Stream<NotesState> mapEventToState(NotesEvent event) async* {
    switch (event.runtimeType) {
      case NewNote:
        yield NewNoteRedirect();
        break;

      case DeleteNote:
        final note = (event as DeleteNote).note;
        try {
          final userId = (await _authRepository.getUser()).id;
          await _notesRepository.delete(userId, note);

          //TODO HOT FIX
          if (state is Content && (state as Content).notes.length == 1) {
            yield Empty();
          }
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          print(e);
          yield Error();
        }
        break;

      case NotesChanged:
        final notes = (event as NotesChanged).notes;
        if (notes.isEmpty) {
          yield Empty();
        } else {
          yield Content(notes);
        }
        break;

      case NotesFetchingThrowError:
        yield Error();
        break;
    }
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }

  void _observeNotes() async {
    final userId = (await _authRepository.getUser()).id;
    _notesSubscription = _notesRepository.get(userId).listen(
      (notes) {
        final event = NotesChanged(notes);
        add(event);
      },
      // ignore: avoid_types_on_closure_parameters
      onError: (Object error) {
        print(error);
        final event = NotesFetchingThrowError();
        add(event);
      }
    );
  }
}