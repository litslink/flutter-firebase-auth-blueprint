abstract class AuthEvent {}

class SignIn extends AuthEvent {
  final String email;
  final String password;

  SignIn(this.email, this.password);
}

class SignUp extends AuthEvent {
  final String email;
  final String password;

  SignUp(this.email, this.password);
}

class SignInWithGoogle extends AuthEvent {}

class RequestPhoneVerification extends AuthEvent {
  final String phoneNumber;

  RequestPhoneVerification(this.phoneNumber);
}

class SignInWithPhone extends AuthEvent {
  final String verificationId;
  final String smsCode;

  SignInWithPhone(this.verificationId, this.smsCode);
}
