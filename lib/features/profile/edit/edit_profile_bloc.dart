import 'dart:io';

import 'package:bloc/bloc.dart';

import '../../../data/model/user.dart';
import '../../../data/repository/auth_repository.dart';
import '../../../data/util/image_manager.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {

  final User user;
  final AuthRepository authRepository;
  final ImageManager imageLoader;
  User _currentUser;
  File _currentPhoto;

  EditProfileBloc(this.user, this.authRepository, this.imageLoader) {
    _currentUser = user;
  }

  @override
  EditProfileState get initialState => ProfileInfo(user);

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is NameChanged) {
      _currentUser = _currentUser.copyWith(
        displayName: event.name
      );
    } else if (event is PhotoChanged) {
      _currentPhoto = event.photo;
    } else if (event is ConfirmChanges) {
      yield Loading();
      await _preparePhoto();
      final containsChanges = await _applyChanges();
      yield EditCompleted(containsChanges);
    }
  }

  Future<bool> _applyChanges() async {
    var containsChanges = false;
    containsChanges |= await authRepository
        .updateUserName(_currentUser.displayName);
    containsChanges |= await authRepository
        .updatePhotoUrl(_currentUser.photoUrl);
    return containsChanges;
  }

  Future<void> _preparePhoto() async {
    if (_currentPhoto != null) {
      final url = await imageLoader.loadUserPhoto(_currentPhoto, user.id);
      _currentUser = _currentUser.copyWith(
        photoUrl: url
      );
    }
  }
}
