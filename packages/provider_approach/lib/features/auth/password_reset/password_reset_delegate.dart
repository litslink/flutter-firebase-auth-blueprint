import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class PasswordResetDelegate {

  void closeScreen();

  void showAuthError();
}

class PasswordResetDelegateImpl extends PasswordResetDelegate {
  final BuildContext context;

  PasswordResetDelegateImpl(this.context);

  @override
  void closeScreen() => Navigator.of(context).pop();

  @override
  void showAuthError() => Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text('Something went wrong. Check your internet connection'),
    )
  );
}
