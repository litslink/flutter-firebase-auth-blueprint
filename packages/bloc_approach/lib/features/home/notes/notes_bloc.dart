import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/notes/notes_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/notes_repository.dart';

import 'notes_event.dart';

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
        final note = (event as NewNote).note;
        try {
          final userId = (await _authRepository.getUser()).id;
          await _notesRepository.add(userId, note);
        // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          print(e);
          yield Error();
        }
        break;

      case DeleteNote:
        final note = (event as DeleteNote).note;
        try {
          final userId = (await _authRepository.getUser()).id;
          await _notesRepository.delete(userId, note);
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
        add(NotesChanged(notes));
      },
      // ignore: avoid_types_on_closure_parameters
      onError: (Object error) {
        print(error);
        add(NotesFetchingThrowError());
      }
    );
  }
}
