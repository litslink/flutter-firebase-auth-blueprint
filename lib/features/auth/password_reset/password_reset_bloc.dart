import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/password_reset/password_reset_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/password_reset/password_reset_state.dart';

class PasswordResetBloc extends Bloc<PasswordResetEvent, PasswordResetState> {

  final AuthRepository authRepository;

  PasswordResetBloc(this.authRepository);

  @override
  PasswordResetState get initialState => EmailInputForm();

  @override
  Stream<PasswordResetState> mapEventToState(PasswordResetEvent event) async* {
    if (event is SubmitEmail) {
      yield Loading();
      try {
        await authRepository.sendPasswordResetEmail(event.email);
        yield ResetInstructionsDelivered();
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        print(e);
        yield AuthError();
      }
    }
  }
}
