import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint/data/util/validation/validation_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validators.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {

  final AuthRepository authRepository;

  SignUpBloc(this.authRepository);

  final _name = ValidationBloc(NameValidator());
  final _email = ValidationBloc(EmailValidator());
  final _password = ValidationBloc(PasswordValidator());
  final _confirmPassword = ValidationBloc(PasswordValidator());

  @override
  SignUpState get initialState => SignUpForm(true, true, true, true);

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    switch (event.runtimeType) {
      case NameChanged:
        final name = (event as NameChanged).name;
        _name.add(name);
        yield SignUpForm(true, true, true, true);
        break;

      case EmailChanged:
        final email = (event as EmailChanged).email;
        _email.add(email);
        yield SignUpForm(true, true, true, true);
        break;

      case PasswordChanged:
        final password = (event as PasswordChanged).password;
        _password.add(password);
        yield SignUpForm(true, true, true, true);
        break;

      case ConfirmPasswordChanged:
        final password = (event as ConfirmPasswordChanged).password;
        _confirmPassword.add(password);
        yield SignUpForm(true, true, true, true);
        break;

      case SignUp:
        yield Loading();
        try {
          final isNameValid = _name.isValid();
          final isEmailValid = _email.isValid();
          final isPasswordValid = _password.isValid();
          final isPasswordEquals = _password.text == _confirmPassword.text;
          if (isNameValid && isEmailValid && isPasswordValid && isPasswordEquals) {
            await authRepository.signUp(_name.text(), _email.text(), _password.text());
            yield Authenticated();
          } else {
            yield SignUpForm(isNameValid, isEmailValid, isPasswordValid, isPasswordEquals);
          }
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          print(e);
          yield AuthError();
          yield SignUpForm(true, true, true, true);
        }
        break;

      case SignIn:
        yield SignInRedirect();
        break;
    }
  }
}
