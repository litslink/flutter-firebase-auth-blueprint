import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_router.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validators.dart';

enum ViewState { inputForm, loading }

class SignInModel extends ChangeNotifier {

  final AuthRepository _authRepository;
  final Validator _emailValidator;
  final Validator _passwordValidator;
  final SignInRouter _router;

  ViewState _state = ViewState.inputForm;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  String _email = '';
  String _password = '';

  SignInModel(this._authRepository, this._emailValidator,
      this._passwordValidator, this._router);

  ViewState get state => _state;
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
      _isEmailValid = _emailValidator.validate(_email);
      _isPasswordValid = _passwordValidator.validate(_password);
      notifyListeners();
      if (_isEmailValid && _isPasswordValid) {
        _state = ViewState.loading;
        notifyListeners();

        await _authRepository.signIn(_email, _password);
        _router.goToHome();
      }
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      //TODO show toast
      print(e);
      _state = ViewState.inputForm;
      notifyListeners();
    }
  }

  void signInWithGoogle() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      await _authRepository.signInWithGoogle();
      _router.goToHome();
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      //TODO show toast
      print(e);
      _state = ViewState.inputForm;
      notifyListeners();
    }
  }

  void _hideErrors() {
    if (!_isEmailValid || !isPasswordValid) {
      _isEmailValid = true;
      _isPasswordValid = true;
      notifyListeners();
    }
  }
}
