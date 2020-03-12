import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/auth_widget.dart';
import 'features/auth/password_reset/password_reset_widget.dart';
import 'features/auth/phone/phone_verification_widget.dart';
import 'features/home/home_widget.dart';
import 'features/profile/profile_widget.dart';
import 'features/splash/splash_widget.dart';
import 'providers.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        initialRoute: SplashWidget.route,
        routes: {
          SplashWidget.route: (_) => SplashWidget(),
          HomeWidget.route: (_) => HomeWidget(),
          AuthWidget.route: (_) => AuthWidget(),
          ProfileWidget.route: (_) => ProfileWidget(),
          PhoneVerificationWidget.route: (_) => PhoneVerificationWidget(),
          PasswordResetWidget.route: (_) => PasswordResetWidget()
        },
      ),
    );
  }
}
