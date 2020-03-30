import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/profile/edit/edit_profile_widget.dart';

abstract class ProfileDelegate {
  void goToEditProfile();

  void goToSignIn();
}

class ProfileDelegateImpl extends ProfileDelegate {
  final BuildContext context;

  ProfileDelegateImpl(this.context);

  @override
  void goToEditProfile() =>
      Navigator.of(context).pushNamed(EditProfileWidget.route);

  @override
  void goToSignIn() => Navigator.of(context)
      .pushNamedAndRemoveUntil(SignInWidget.route, (route) => false);
}
