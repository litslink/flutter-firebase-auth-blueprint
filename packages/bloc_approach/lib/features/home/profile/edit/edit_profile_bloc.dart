import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/user.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/image_manager.dart';

import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final User user;
  final AuthRepository authRepository;
  final ImageManager imageLoader;

  User _currentUser;
  File _currentPhoto;

  EditProfileBloc(
    this.user,
    this.authRepository,
    this.imageLoader) {
    _currentUser = user;
  }

  @override
  EditProfileState get initialState => ProfileInfo(user);

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    switch (event.runtimeType) {
      case NameChanged:
        final name = (event as NameChanged).name;
        _currentUser = _currentUser.copyWith(
          displayName: name
        );
        break;

      case PhotoChanged:
        _currentPhoto = (event as PhotoChanged).photo;
        break;

      case ConfirmChanges:
        yield Loading();
        try {
          await _preparePhoto();
          await authRepository.updateUserName(_currentUser.displayName);
          await authRepository.updatePhotoUrl(_currentUser.photoUrl);
          yield EditCompleted();
        // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          print(e);
          yield Error();
        }
        break;
    }
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
