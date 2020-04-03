import 'package:flutter_firebase_auth_blueprint_common/data/model/user.dart';

abstract class ProfileState {}

class Loading extends ProfileState {}

class ProfileInfo extends ProfileState {
  final User user;
  final bool isNotificationEnabled;

  // ignore: avoid_positional_boolean_parameters
  ProfileInfo(this.user, this.isNotificationEnabled);
}

class AuthenticationRequired extends ProfileState {}

class EditProfileRedirect extends ProfileState {
  final User user;

  EditProfileRedirect(this.user);
}
