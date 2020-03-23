import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {

  final AuthRepository authRepository;

  SignUpBloc(this.authRepository);

  @override
  SignUpState get initialState => SignUpForm();

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUp) {
      yield Loading();
      try {
        await authRepository.signUp(event.name, event.email, event.password);
        yield Authenticated();
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        print(e);
        yield AuthError();
        yield SignUpForm();
      }
    } else if (event is SignIn) {
      yield SignInRedirect();
    }
  }
}
