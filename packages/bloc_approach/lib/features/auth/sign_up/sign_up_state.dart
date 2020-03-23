abstract class SignUpState {}

class SignUpForm extends SignUpState {
  final bool isNameValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;

  // ignore: avoid_positional_boolean_parameters
  SignUpForm(this.isNameValid, this.isEmailValid,
      this.isPasswordValid, this.isConfirmPasswordValid);
}

class Loading extends SignUpState {}

class Authenticated extends SignUpState {}

class SignInRedirect extends SignUpState {}

class AuthError extends SignUpState {}
