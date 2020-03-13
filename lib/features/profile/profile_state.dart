import '../../data/model/user.dart';

abstract class ProfileState {}

class Loading extends ProfileState {}

class ProfileInfo extends ProfileState {
  final User user;

  ProfileInfo(this.user);
}

class AuthenticationRequired extends ProfileState {}
