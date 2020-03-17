import '../../../data/model/user.dart';

abstract class EditProfileState {}

class Loading extends EditProfileState {}

class ProfileInfo extends EditProfileState {
  final User user;

  ProfileInfo(this.user);
}

class EditCompleted extends EditProfileState {
  final bool containsChanges;

  // ignore: avoid_positional_boolean_parameters
  EditCompleted(this.containsChanges);
}

class Error extends EditProfileState {}
