abstract class SignInState {}

class SignInForm extends SignInState {}

class Loading extends SignInState {}

class Authenticated extends SignInState {}

class PhoneVerificationRedirect extends SignInState {}

class ResetPasswordRedirect extends SignInState {}

class CreateAccountRedirect extends SignInState {}

class AuthError extends SignInState {}
