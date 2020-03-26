import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/home_widget.dart';

abstract class SignInRouter {

  void goToHome();
}

class SignInRouterImpl extends SignInRouter {

  final BuildContext context;

  SignInRouterImpl(this.context);

  @override
  void goToHome() => Navigator.of(context).popAndPushNamed(HomeWidget.route);
}
