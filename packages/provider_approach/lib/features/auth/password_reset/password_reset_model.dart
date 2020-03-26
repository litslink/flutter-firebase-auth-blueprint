import 'package:flutter_firebase_auth_blueprint/features/auth/password_reset/password_reset_delegate.dart';
import 'package:flutter_firebase_auth_blueprint/features/util/base_model.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validators.dart';

enum ViewState {
  inputForm,
  loading,
  done
}

class PasswordResetModel extends BaseModel<ViewState> {
  final AuthRepository _authRepository;
  final Validator _emailValidator;
  final PasswordResetDelegate _delegate;

  bool _isEmailValid = true;
  String _email = '';

  PasswordResetModel(
    this._authRepository,
    this._emailValidator,
    this._delegate);

  @override
  ViewState get initialState => ViewState.inputForm;

  bool get isEmailValid => _isEmailValid;

  void emailChanged(String email) {
    _email = email;
    if (!_isEmailValid) {
      notify(() {
        _isEmailValid = true;
      });
    }
  }

  void submitEmail() async {
    notify(() {
      _isEmailValid = _emailValidator.validate(_email);
    });
    if (_isEmailValid) {
      state = ViewState.loading;
      try {
        await _authRepository.sendPasswordResetEmail(_email);
        state = ViewState.done;
      // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        state = ViewState.inputForm;
        print(e);
        _delegate.showAuthError();
      }
    }
  }

  void cancel() {
    _delegate.closeScreen();
  }
}
