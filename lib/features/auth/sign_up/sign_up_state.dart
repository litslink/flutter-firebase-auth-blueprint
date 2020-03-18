abstract class SignUpState {}

class SignUpForm extends SignUpState {}

class Loading extends SignUpState {}

class Authenticated extends SignUpState {}

class SignInRedirect extends SignUpState {}

class AuthError extends SignUpState {}
