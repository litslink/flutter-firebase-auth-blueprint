import 'package:bloc/bloc.dart';

import '../../repository/auth_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {

  final AuthRepository authRepository;

  ProfileBloc(this.authRepository);

  @override
  ProfileState get initialState => Loading();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is FetchProfileInfo) {
      final user = await authRepository.getUser();
      yield ProfileInfo(user);
    } else if (event is SignOut) {
      yield Loading();
      await authRepository.signOut();
      yield AuthenticationRequired();
    }
  }
}
