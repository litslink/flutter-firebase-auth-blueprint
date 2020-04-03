import 'package:flutter_firebase_auth_blueprint_common/data/model/user.dart';

abstract class EditProfileState {}

class Loading extends EditProfileState {}

class ProfileInfo extends EditProfileState {
  final User user;

  ProfileInfo(this.user);
}

class EditCompleted extends EditProfileState {}

class Error extends EditProfileState {}
