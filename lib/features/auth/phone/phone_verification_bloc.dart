import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_state.dart';

class PhoneVerificationBloc
    extends Bloc<PhoneVerificationEvent, PhoneVerificationState> {

  final AuthRepository authRepository;

  PhoneVerificationBloc(this.authRepository);

  @override
  PhoneVerificationState get initialState => PhoneInputForm();

  @override
  Stream<PhoneVerificationState> mapEventToState(
      PhoneVerificationEvent event) async* {

    if (event is ConfirmPhone) {
      yield Loading();
      try {
        final verificationId = await authRepository
            .requestPhoneVerification(event.phoneNumber);
        yield OtpInputForm(verificationId);
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        print(e);
        yield AuthError();
      }
    } else if (event is OtpChanged) {
      if (state is OtpInputForm && event.otp.length > 5) {
        final verificationId = (state as OtpInputForm).verificationId;

        yield Loading();
        try {
          await authRepository.signInWithPhone(verificationId, event.otp);
          yield Authenticated();
        // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          print(e);
          yield AuthError();
        }
      }
    }
  }
}
