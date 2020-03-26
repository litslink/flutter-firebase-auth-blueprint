import 'package:flutter/foundation.dart';
import 'package:flutter_firebase_auth_blueprint/features/splash/splash_router.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';

class SplashModel extends ChangeNotifier {

  final AuthRepository _authRepository;
  final SplashRouter _router;

  SplashModel(this._authRepository, this._router) {
    checkAuth();
  }

  void checkAuth() async {
    final currentUser = await _authRepository.getUser();
    if (currentUser != null) {
      _router.goToHome();
    } else {
      _router.goToAuthentication();
    }
  }
}
