import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint/data/util/validation/validation_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
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
    switch (event.runtimeType) {
      case EmailChanged:
        final email = (event as EmailChanged).email;
        _email.add(email);
        yield SignInForm(true, true);
        break;

      case PasswordChanged:
        final password = (event as PasswordChanged).password;
        _password.add(password);
        yield SignInForm(true, true);
        break;

      case SignIn:
        yield Loading();
        try {
          final isEmailValid = _email.isValid();
          final isPasswordValid = _password.isValid();
          if (isEmailValid && isPasswordValid) {
            await authRepository.signIn(_email.text(), _password.text());
            yield Authenticated();
          } else {
            yield SignInForm(isEmailValid, isPasswordValid);
          }
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          print(e);
          yield AuthError();
          yield SignInForm(true, true);
        }
        break;

      case SignInWithGoogle:
        yield Loading();
        try {
          await authRepository.signInWithGoogle();
          yield Authenticated();
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          print(e);
          yield AuthError();
          yield SignInForm(true, true);
        }
        break;

      case SignInWithPhoneNumber:
        yield PhoneVerificationRedirect();
        break;

      case ResetPassword:
        yield ResetPasswordRedirect();
        break;

      case CreateAccount:
        yield CreateAccountRedirect();
        break;
    }
  }

  @override
  Future<void> close() {
    _email.close();
    _password.close();
    return super.close();
  }
}
