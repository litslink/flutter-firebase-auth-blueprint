import 'package:flutter_firebase_auth_blueprint/features/profile/preview/profile_delegate.dart';
import 'package:flutter_firebase_auth_blueprint/features/util/base_model.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/user.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/settings_repository.dart';

enum ViewState { userLoaded, loading, signOut }

class ProfileModel extends BaseModel<ViewState> {
  final AuthRepository _authRepository;
  final SettingsRepository _settingsRepository;
  final ProfileDelegate _delegate;
  User _user;
  bool isNotificationsEnabled = false;

  ProfileModel(this._authRepository, this._settingsRepository, this._delegate);

  User get user => _user;

  @override
  ViewState get initialState => ViewState.loading;

  void loadUserInfo() async {
    try {
      _user = await _authRepository.getUser();
      if (_user != null) {
        isNotificationsEnabled =
            await _settingsRepository.isNotificationEnabled(_user.id);
        state = ViewState.userLoaded;
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print(e.toString());
      state = ViewState.userLoaded;
    }
  }

  void setNotificationsEnabled({bool value}) async {
    try {
      if (value) {
        await _settingsRepository.enableNotification(_user.id);
        isNotificationsEnabled = true;
      } else {
        await _settingsRepository.disableNotification(_user.id);
        isNotificationsEnabled = false;
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      state = ViewState.userLoaded;
    }
  }

  void logOut() async {
    try {
      state = ViewState.signOut;
      await _authRepository.signOut();
      _delegate.goToSignIn();
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      state = ViewState.loading;
    }
  }

  void editProfile() {
    _delegate.goToEditProfile();
  }
}
