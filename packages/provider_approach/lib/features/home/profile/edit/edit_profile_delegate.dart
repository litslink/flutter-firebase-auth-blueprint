import 'package:flutter/material.dart';

abstract class EditProfileDelegate {

  void closeScreen();

  void showEditError();
}

class EditProfileDelegateImpl extends EditProfileDelegate {
  final BuildContext context;

  EditProfileDelegateImpl(this.context);

  @override
  void closeScreen() => Navigator.of(context).pop();

  @override
  void showEditError() => Scaffold.of(context).showSnackBar(
    SnackBar(
        content: Text('Profile update failed'),
    )
  );
}
