abstract class ValidationState {}

class Empty extends ValidationState {}

class Valid extends ValidationState {
  final String text;

  Valid(this.text);
}

class Invalid extends ValidationState {}
