import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint/data/util/validation/validation_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validation_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validators.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {

  final AuthRepository authRepository;

  SignInBloc(this.authRepository);

  final _email = ValidationBloc(EmailValidator());
  final _password = ValidationBloc(PasswordValidator());

  @override
  SignInState get initialState => SignInForm(true, true);

  @override
  Stream<SignInState> mapEventToState(SignInEvent event) async* {
    if (event is EmailChanged) {
      _email.add(event.email);
      yield SignInForm(true, true);
    } else if (event is PasswordChanged) {
      _password.add(event.password);
      yield SignInForm(true, true);
    } else if (event is SignIn) {
      yield Loading();
      try {
        if (_email.state is Valid && _password.state is Valid) {
          await authRepository.signIn(
              (_email.state as Valid).text,
              (_password.state as Valid).text
          );
          yield Authenticated();
        } else {
          yield SignInForm(
              _email.state is Valid,
              _password.state is Valid
          );
        }
      } catch (e) { // ignore: avoid_catches_without_on_clauses
        print(e);
        yield AuthError();
        yield SignInForm(true, true);
      }
    } else if (event is SignInWithGoogle) {
      yield Loading();
      try {
        await authRepository.signInWithGoogle();
        yield Authenticated();
      } catch (e) { // ignore: avoid_catches_without_on_clauses
        print(e);
        yield AuthError();
        yield SignInForm(true, true);
      }
    } else if (event is SignInWithPhoneNumber) {
      yield PhoneVerificationRedirect();
    } else if (event is ResetPassword) {
      yield ResetPasswordRedirect();
    } else if (event is CreateAccount) {
      yield CreateAccountRedirect();
    }
  }

  @override
  Future<Function> close() {
    super.close();
    _email.close();
    _password.close();
  }
}
