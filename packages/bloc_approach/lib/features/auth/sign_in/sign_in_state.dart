abstract class SignInState {}

class SignInForm extends SignInState {
  final bool isEmailValid;
  final bool isPasswordValid;

  // ignore: avoid_positional_boolean_parameters
  SignInForm(this.isEmailValid, this.isPasswordValid);
}

class Loading extends SignInState {}

class Authenticated extends SignInState {}

class PhoneVerificationRedirect extends SignInState {}

class ResetPasswordRedirect extends SignInState {}

class CreateAccountRedirect extends SignInState {}

class AuthError extends SignInState {}
