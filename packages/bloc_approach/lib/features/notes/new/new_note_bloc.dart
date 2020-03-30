import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/new/new_note_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/new/new_note_state.dart';

class NewNoteBloc extends Bloc<NewNoteEvent, NewNoteState> {

  @override
  NewNoteState get initialState => null;

  @override
  Stream<NewNoteState> mapEventToState(NewNoteEvent event) {
    // TODO: implement mapEventToState
    return null;
  }
}
