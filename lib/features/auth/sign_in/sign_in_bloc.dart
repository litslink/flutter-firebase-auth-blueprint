import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {

  final AuthRepository authRepository;

  SignInBloc(this.authRepository);

  @override
  SignInState get initialState => SignInForm();

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is SignIn) {
      yield Loading();
      try {
        await authRepository.signIn(event.email, event.password);
        yield Authenticated();
      } catch (e) { // ignore: avoid_catches_without_on_clauses
        print(e);
        yield AuthError();
      }
    } else if (event is SignInWithGoogle) {
      yield Loading();
      try {
        await authRepository.signInWithGoogle();
        yield Authenticated();
      } catch (e) { // ignore: avoid_catches_without_on_clauses
        print(e);
        yield AuthError();
      }
    } else if (event is SignInWithPhoneNumber) {
      yield PhoneVerificationRedirect();
    } else if (event is ResetPassword) {
      yield ResetPasswordRedirect();
    } else if (event is CreateAccount) {
      yield CreateAccountRedirect();
    }
  }
}
