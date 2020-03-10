import 'package:bloc/bloc.dart';

import '../../repository/auth_repository.dart';

import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {

  final AuthRepository authRepository;

  SplashBloc(this.authRepository);

  @override
  SplashState get initialState => Loading();

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is CheckAuthentication) {
      final currentUser = await authRepository.getUser();
      if (currentUser != null) {
        yield Authenticated();
      } else {
        yield AuthenticationRequired();
      }
    }
  }
}
