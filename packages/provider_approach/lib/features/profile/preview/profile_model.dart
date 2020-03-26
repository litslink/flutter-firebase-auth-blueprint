import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_auth_blueprint/features/profile/preview/profile_router.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/user.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/settings_repository.dart';

enum ViewState { userLoaded, loading, signOut }

class ProfileModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SettingsRepository _settingsRepository;
  final ProfileRouter _router;
  User user;
  bool isNotificationsEnabled = false;
  ViewState _state = ViewState.loading;

  ProfileModel(this._authRepository, this._settingsRepository, this._router);

  ViewState get state => _state;

  void loadUserInfo() async {
    try {
      user = await _authRepository.getUser();
      isNotificationsEnabled =
          await _settingsRepository.isNotificationEnabled(user.id);
      if (user != null) {
        _state = ViewState.userLoaded;
        notifyListeners();
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print(e);
      _state = ViewState.userLoaded;
      notifyListeners();
    }
  }

  void setNotificationsEnabled({bool value}) async {
    try {
      if (value) {
        await _settingsRepository.enableNotification(user.id);
        isNotificationsEnabled = true;
      } else {
        await _settingsRepository.disableNotification(user.id);
        isNotificationsEnabled = false;
      }
      notifyListeners();
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print(e);
      _state = ViewState.userLoaded;
      notifyListeners();
    }
  }

  void logOut() async {
    try {
      _state = ViewState.signOut;
      notifyListeners();
      await _authRepository.signOut();
      _router.goToSignIn();
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print(e);
      _state = ViewState.loading;
      notifyListeners();
    }
  }
}
