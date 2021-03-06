import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_delegate.dart';
import 'package:flutter_firebase_auth_blueprint/features/util/base_model.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validators.dart';

enum ViewState {
  inputForm,
  loading
}

class SignInModel extends BaseModel<ViewState> {
  final AuthRepository _authRepository;
  final Validator _emailValidator;
  final Validator _passwordValidator;
  final SignInDelegate _delegate;

  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  String _email = '';
  String _password = '';

  SignInModel(
    this._authRepository,
    this._emailValidator,
    this._passwordValidator,
    this._delegate);

  @override
  ViewState get initialState => ViewState.inputForm;

  bool get isEmailValid => _isEmailValid;
  bool get isPasswordValid => _isPasswordValid;

  void emailChanged(String email) {
    _email = email;
    _hideErrors();
  }

  void passwordChanged(String password) {
    _password = password;
    _hideErrors();
  }

  void signIn() async {
    try {
      notify(() {
        _isEmailValid = _emailValidator.validate(_email);
        _isPasswordValid = _passwordValidator.validate(_password);
      });
      if (_isEmailValid && _isPasswordValid) {
        state = ViewState.loading;

        await _authRepository.signIn(_email, _password);
        _delegate.navigateToHome();
      }
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      _delegate.showAuthError();
      print(e);
      state = ViewState.inputForm;
    }
  }

  void signInWithGoogle() async {
    state = ViewState.loading;
    try {
      await _authRepository.signInWithGoogle();
      _delegate.navigateToHome();
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      _delegate.showAuthError();
      print(e);
      state = ViewState.inputForm;
      notifyListeners();
    }
  }

  void resetPassword() {
    _delegate.navigateToResetPassword();
  }

  void signUp() {
    _delegate.navigateToSignUp();
  }

  void signUpWithPhone() {
    _delegate.navigateToPhoneVerification();
  }

  void _hideErrors() {
    if (!_isEmailValid || !isPasswordValid) {
      notify(() {
        _isEmailValid = true;
        _isPasswordValid = true;
      });
    }
  }
}
