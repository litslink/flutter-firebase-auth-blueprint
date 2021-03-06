import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/profile/edit/edit_profile_widget.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/user.dart';

abstract class ProfileDelegate {

  void navigateToEditProfile(User user);

  void navigateToSignIn();

  void showError();
}

class ProfileDelegateImpl extends ProfileDelegate {
  final BuildContext context;

  ProfileDelegateImpl(this.context);

  @override
  void navigateToEditProfile(User user) => Navigator.of(context).pushNamed(EditProfileWidget.route, arguments: user);

  @override
  void navigateToSignIn() => Navigator.of(context).pushNamedAndRemoveUntil(SignInWidget.route, (route) => false);

  @override
  void showError() => Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text('Something went wrong'),
    )
  );
}
