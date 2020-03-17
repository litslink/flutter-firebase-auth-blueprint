abstract class SignInEvent {}

class SignIn extends SignInEvent {
  final String email;
  final String password;

  SignIn(this.email, this.password);
}

class SignInWithGoogle extends SignInEvent {}

class SignInWithPhoneNumber extends SignInEvent {}

class ResetPassword extends SignInEvent {}

class CreateAccount extends SignInEvent {}
