abstract class AuthEvent {}

class SignUp extends AuthEvent {
  final String email;
  final String password;

  SignUp(this.email, this.password);
}
