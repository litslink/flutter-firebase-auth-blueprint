abstract class PasswordResetEvent {}

class SubmitEmail extends PasswordResetEvent {
  final String email;

  SubmitEmail(this.email);
}
