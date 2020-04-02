import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/settings_repository.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;
  final SettingsRepository settingsRepository;

  ProfileBloc(this.authRepository, this.settingsRepository);

  @override
  ProfileState get initialState => Loading();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    switch (event.runtimeType) {
      case FetchProfileInfo:
        final user = await authRepository.getUser();
        final isNotificationEnabled = await settingsRepository.isNotificationEnabled(user.id);
        yield ProfileInfo(user, isNotificationEnabled);
        break;

      case SignOut:
        yield Loading();
        await authRepository.signOut();
        yield AuthenticationRequired();
        break;

      case EnableNotification:
        final user = await authRepository.getUser();
        settingsRepository.enableNotification(user.id);
        break;

      case DisableNotification:
        final user = await authRepository.getUser();
        settingsRepository.disableNotification(user.id);
        break;
    }
  }
}
