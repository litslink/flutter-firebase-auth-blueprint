import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/auth_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/settings_repository.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final SettingsRepository _settingsRepository;

  StreamSubscription _authSubscription;

  ProfileBloc(this._authRepository, this._settingsRepository) {
    _observeAuthChanges();
  }

  @override
  ProfileState get initialState => Loading();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    switch (event.runtimeType) {
      case AuthChanged:
        final user = (event as AuthChanged).user;
        final isNotificationEnabled = await _settingsRepository.isNotificationEnabled(user.id);
        yield ProfileInfo(user, isNotificationEnabled);
        break;

      case SignOut:
        yield Loading();
        await _authRepository.signOut();
        yield AuthenticationRequired();
        break;

      case EnableNotification:
        final user = await _authRepository.getUser();
        yield ProfileInfo(user, true);
        _settingsRepository.enableNotification(user.id);
        break;

      case DisableNotification:
        final user = await _authRepository.getUser();
        yield ProfileInfo(user, false);
        _settingsRepository.disableNotification(user.id);
        break;

      case EditProfile:
        if (state is ProfileInfo) {
          final user = (state as ProfileInfo).user;
          yield EditProfileRedirect(user);
        }
        break;
    }
  }


  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  void _observeAuthChanges() {
    _authSubscription = _authRepository.authState().listen(_onAuthChanged);
  }

  void _onAuthChanged(AuthState state) async {
    if (state is Authenticated) {
      add(AuthChanged(state.user));
    }
  }
}
