import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_delegate.dart';
import 'package:flutter_firebase_auth_blueprint/features/util/base_model.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validators.dart';

enum ViewState {
  inputForm,
  loading
}

class SignUpModel extends BaseModel<ViewState> {
  final AuthRepository _authRepository;
  final Validator _nameValidator;
  final Validator _emailValidator;
  final Validator _passwordValidator;
  final SignUpDelegate _delegate;

  SignUpModel(
    this._authRepository,
    this._nameValidator,
    this._emailValidator,
    this._passwordValidator,
    this._delegate);

  @override
  ViewState get initialState => ViewState.inputForm;

  bool _isNameValid = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;
  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool get isNameValid => _isNameValid;
  bool get isEmailValid => _isEmailValid;
  bool get isPasswordValid => _isPasswordValid;
  bool get isConfirmPasswordValid => _isConfirmPasswordValid;

  void nameChanged(String name) {
    _name = name;
    _hideErrors();
  }

  void emailChanged(String email) {
    _email = email;
    _hideErrors();
  }

  void passwordChanged(String password) {
    _password = password;
    _hideErrors();
  }

  void confirmPasswordChanged(String password) {
    _confirmPassword = password;
    _hideErrors();
  }

  void signUp() async {
    try {
      notify(() {
        _isNameValid = _nameValidator.validate(_name);
        _isEmailValid = _emailValidator.validate(_email);
        _isPasswordValid = _passwordValidator.validate(_password);
        _isConfirmPasswordValid = _isPasswordValid && (_password == _confirmPassword);
      });
      if (_isNameValid && _isEmailValid && _isPasswordValid && _isConfirmPasswordValid) {
        state = ViewState.loading;

        await _authRepository.signUp(_name, _email, _password);
        _delegate.navigateToHome();
      }
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      _delegate.showAuthError();
      print(e);
      state = ViewState.inputForm;
    }
  }

  void signIn() {
    _delegate.navigateToSignIn();
  }

  void _hideErrors() {
    if (!_isEmailValid || !isPasswordValid) {
      notify(() {
        _isNameValid = true;
        _isEmailValid = true;
        _isPasswordValid = true;
        _isConfirmPasswordValid = true;
      });
    }
  }
}
