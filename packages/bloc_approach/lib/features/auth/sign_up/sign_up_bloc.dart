import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint/data/util/validation/validation_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validation_state.dart';
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
    if (event is NameChanged) {
      _name.add(event.name);
      yield SignUpForm(true, true, true, true);
    } else if (event is EmailChanged) {
      _email.add(event.email);
      yield SignUpForm(true, true, true, true);
    } else if (event is PasswordChanged) {
      _password.add(event.password);
      yield SignUpForm(true, true, true, true);
    } else if (event is ConfirmPasswordChanged) {
      _confirmPassword.add(event.password);
      yield SignUpForm(true, true, true, true);
    } else if (event is SignUp) {
      yield Loading();
      try {
        bool isPasswordEquals() {
          return (_password.state as Valid).text
              == (_confirmPassword.state as Valid).text;
        }
        if (_name.state is Valid
            && _email.state is Valid
            && _password.state is Valid
            && _confirmPassword.state is Valid
            && isPasswordEquals()
        ) {
          await authRepository.signUp(
              (_name.state as Valid).text,
              (_email.state as Valid).text,
              (_password.state as Valid).text
          );
          yield Authenticated();
        } else {
          yield SignUpForm(
            _name.state is Valid,
            _email.state is Valid,
            _password.state is Valid,
            _confirmPassword.state is Valid &&
                (_confirmPassword.state as Valid).text
                    == (_password.state as Valid).text
          );
        }
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        print(e);
        yield AuthError();
        yield SignUpForm(true, true, true, true);
      }
    } else if (event is SignIn) {
      yield SignInRedirect();
    }
  }
}
