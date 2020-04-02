import 'package:bloc/bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';

class PhoneVerificationBloc extends Bloc<PhoneVerificationEvent, PhoneVerificationState> {
  final AuthRepository authRepository;

  PhoneVerificationBloc(this.authRepository);

  @override
  PhoneVerificationState get initialState => PhoneInputForm();

  @override
  Stream<PhoneVerificationState> mapEventToState(PhoneVerificationEvent event) async* {
    switch (event.runtimeType) {
      case ConfirmPhone:
        yield Loading();
        try {
          final phoneNumber = (event as ConfirmPhone).phoneNumber;
          final verificationId = await authRepository.requestPhoneVerification(phoneNumber);
          yield OtpInputForm(verificationId);
        // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          print(e);
          yield AuthError();
        }
        break;

      case OtpChanged:
        final otp = (event as OtpChanged).otp;
        if (state is OtpInputForm && otp.length > 5) {
          final verificationId = (state as OtpInputForm).verificationId;
          yield Loading();
          try {
            await authRepository.signInWithPhone(verificationId, otp);
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
