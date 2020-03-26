import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/splash/splash_model.dart';
import 'package:flutter_firebase_auth_blueprint/features/splash/splash_router.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:provider/provider.dart';

class SplashWidget extends StatelessWidget {

  static final String route  = '/';

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    final router = SplashRouterImpl(context);
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => SplashModel(authRepository, router),
        child: Consumer<SplashModel>(
          builder: (_, model, __) {
            return Center(child: CircularProgressIndicator());
          },
        ),
      )
    );
  }
}
