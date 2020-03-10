import 'package:bloc/bloc.dart';

import '../../repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final AuthRepository authRepository;

  AuthBloc(this.authRepository);

  @override
  AuthState get initialState => AuthRequired();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignUp) {
      yield Loading();
      await authRepository.signUp(event.email, event.password);
      final currentUser = await authRepository.getUser();
      yield AuthSuccessful(currentUser.displayName);
    }
  }
}
