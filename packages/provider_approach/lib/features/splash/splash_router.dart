import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/home_widget.dart';

abstract class SplashRouter {

  void goToHome();

  void goToAuthentication();
}

class SplashRouterImpl extends SplashRouter {

  final BuildContext context;

  SplashRouterImpl(this.context);

  @override
  void goToAuthentication() => Navigator.of(context).popAndPushNamed(SignInWidget.route);

  @override
  void goToHome() => Navigator.of(context).popAndPushNamed(HomeWidget.route);
}
