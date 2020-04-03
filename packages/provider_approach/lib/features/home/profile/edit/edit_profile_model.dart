import 'dart:io';
import 'package:flutter_firebase_auth_blueprint/features/util/base_model.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/user.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/image_manager.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validators.dart';

import 'edit_profile_delegate.dart';

enum ViewState { profileInfo, loading}

class EditProfileModel extends BaseModel<ViewState> {
  final AuthRepository _authRepository;
  final EditProfileDelegate _delegate;
  final ImageManager _imageManager;
  final Validator _nameValidator;
  final User _user;
  String _newName;
  bool _isNewNameValid = true;
  File _pickedPhoto;

  EditProfileModel(
    this._user,
    this._authRepository,
    this._delegate,
    this._imageManager,
    this._nameValidator);

  File get pickedPhoto => _pickedPhoto;

  bool get isNewNameValid => _isNewNameValid;

  User get user => _user;

  @override
  ViewState get initialState => ViewState.profileInfo;

  void nameChanged(String newName) {
    _newName = newName;
    if (!_isNewNameValid) {
      notify(() {
        _isNewNameValid = true;
      });
    }
  }

  void updateUserProfile() async {
    if (checkName()) {
      state = ViewState.loading;
      try {
        if (_pickedPhoto != null) {
          final photoUrl =
              await _imageManager.loadUserPhoto(_pickedPhoto, _user.id);
          await _authRepository.updatePhotoUrl(photoUrl);
        }
        if (_newName != _user.displayName) {
          await _authRepository.updateUserName(_newName);
        }
        _delegate.closeScreen();
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        print(e.toString());
        _delegate.showEditError();
        state = ViewState.profileInfo;
      }
    }
  }

  void pickPhoto(File file) {
    notify(() {
      _pickedPhoto = file;
    });
  }

  bool checkName() {
    notify(() {
      _isNewNameValid = _nameValidator.validate(_newName);
    });
    return _isNewNameValid;
  }
}
