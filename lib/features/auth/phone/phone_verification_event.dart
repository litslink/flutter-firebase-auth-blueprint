abstract class PhoneVerificationEvent {}

class ConfirmPhone extends PhoneVerificationEvent {
  final String phoneNumber;

  ConfirmPhone(this.phoneNumber);
}

class OtpChanged extends PhoneVerificationEvent {
  final String otp;

  OtpChanged(this.otp);
}
