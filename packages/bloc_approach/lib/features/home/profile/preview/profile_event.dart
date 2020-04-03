import 'package:flutter_firebase_auth_blueprint_common/data/model/user.dart';

abstract class ProfileEvent {}

class AuthChanged extends ProfileEvent {
  final User user;

  AuthChanged(this.user);
}

class SignOut extends ProfileEvent {}

class EnableNotification extends ProfileEvent {}

class DisableNotification extends ProfileEvent {}

class EditProfile extends ProfileEvent {}
