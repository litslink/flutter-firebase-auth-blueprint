abstract class SignInEvent {}

class EmailChanged extends SignInEvent {
  final String email;

  EmailChanged(this.email);
}

class PasswordChanged extends SignInEvent {
  final String password;

  PasswordChanged(this.password);
}

class SignIn extends SignInEvent {}

class SignInWithGoogle extends SignInEvent {}

class SignInWithPhoneNumber extends SignInEvent {}

class ResetPassword extends SignInEvent {}

class CreateAccount extends SignInEvent {}
