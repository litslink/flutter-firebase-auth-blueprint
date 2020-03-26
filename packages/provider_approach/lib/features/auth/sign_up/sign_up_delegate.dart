import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/home_widget.dart';

abstract class SignUpDelegate {

  void navigateToHome();

  void navigateToSignIn();

  void showAuthError();
}

class SignUpDelegateImpl extends SignUpDelegate {
  final BuildContext context;

  SignUpDelegateImpl(this.context);

  @override
  void navigateToHome() => Navigator.of(context).popAndPushNamed(HomeWidget.route);

  @override
  void navigateToSignIn() => Navigator.of(context).popAndPushNamed(SignInWidget.route);

  @override
  void showAuthError() => Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text('Something went wrong. Check your internet connection'),
    )
  );
}
