abstract class AuthState {}

class Loading extends AuthState {}

class AuthRequired extends AuthState {}

class PhoneVerificationStarted extends AuthState {
  final String verificationId;

  PhoneVerificationStarted(this.verificationId);
}

class PasswordResetStarted extends AuthState {}

class AuthSuccessful extends AuthState {
  final String name;

  AuthSuccessful(this.name);
}
