abstract class NewNoteEvent {}

class TitleChanged extends NewNoteEvent {
  final String title;

  TitleChanged(this.title);
}

class TextChanged extends NewNoteEvent {
  final String text;

  TextChanged(this.text);
}

class SaveNote extends NewNoteEvent {}
