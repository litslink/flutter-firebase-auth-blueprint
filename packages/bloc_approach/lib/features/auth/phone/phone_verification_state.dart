abstract class PhoneVerificationState {}

class PhoneInputForm extends PhoneVerificationState {}

class OtpInputForm extends PhoneVerificationState {
  final String verificationId;

  OtpInputForm(this.verificationId);
}

class Loading extends PhoneVerificationState {}

class AuthError extends PhoneVerificationState {}

class Authenticated extends PhoneVerificationState {}
