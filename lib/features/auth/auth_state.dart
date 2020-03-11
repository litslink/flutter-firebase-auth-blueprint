abstract class AuthState {}

class Loading extends AuthState {}

class AuthRequired extends AuthState {}

class PhoneVerificationStarted extends AuthState {
  final String verificationId;

  PhoneVerificationStarted(this.verificationId);
}

class AuthSuccessful extends AuthState {
  final String name;

  AuthSuccessful(this.name);
}
