abstract class NewNoteState {}

class Loading extends NewNoteState {}

class InputForm extends NewNoteState {
  final bool isTitleValid;
  final bool isTextValid;

  // ignore: avoid_positional_boolean_parameters
  InputForm(this.isTitleValid, this.isTextValid);
}

class NotesRedirect extends NewNoteState {}

class Error extends NewNoteState {}
