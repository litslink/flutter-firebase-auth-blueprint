import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_blueprint/features/profile/preview/profile_widget.dart';

// ignore: one_member_abstracts
abstract class EditProfileDelegate {
  void goToProfilePreview();

  void showEditError();
}

class EditProfileDelegateImpl extends EditProfileDelegate {
  final BuildContext context;

  EditProfileDelegateImpl(this.context);

  @override
  void showEditError() => Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Profile update failed'),
      ));

  @override
  void goToProfilePreview() =>
      Navigator.of(context).pushReplacementNamed(ProfileWidget.route);
}
