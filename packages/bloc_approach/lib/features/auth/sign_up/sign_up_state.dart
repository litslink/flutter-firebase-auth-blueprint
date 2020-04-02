abstract class SignUpState {}

class SignUpForm extends SignUpState {
  final bool isNameValid;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isConfirmPasswordValid;

  SignUpForm(
    // ignore: avoid_positional_boolean_parameters
    this.isNameValid,
    this.isEmailValid,
    this.isPasswordValid,
    this.isConfirmPasswordValid);
}

class Loading extends SignUpState {}

class Authenticated extends SignUpState {}

class AuthError extends SignUpState {}

class SignInRedirect extends SignUpState {}
