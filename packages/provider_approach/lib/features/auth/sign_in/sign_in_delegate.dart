import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/password_reset/password_reset_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/home_widget.dart';

abstract class SignInDelegate {

  void navigateToHome();

  void navigateToResetPassword();

  void navigateToSignUp();

  void navigateToPhoneVerification();

  void showAuthError();
}

class SignInDelegateImpl extends SignInDelegate {
  final BuildContext context;

  SignInDelegateImpl(this.context);

  @override
  void navigateToHome() => Navigator.of(context).popAndPushNamed(HomeWidget.route);

  @override
  void navigateToResetPassword() => Navigator.of(context).pushNamed(PasswordResetWidget.route);

  @override
  void navigateToSignUp() => Navigator.of(context).popAndPushNamed(SignUpWidget.route);

  @override
  void navigateToPhoneVerification() => Navigator.of(context).popAndPushNamed(PhoneVerificationWidget.route);

  @override
  void showAuthError() => Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text('Something went wrong. Check your internet connection'),
    )
  );
}
