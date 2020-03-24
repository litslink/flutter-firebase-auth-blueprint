import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:provider/provider.dart';

class SplashWidget extends StatelessWidget {

  static final String route  = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSplashListener(context),
    );
  }

  Widget _buildSplashListener(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    return Center(child: CircularProgressIndicator());
  }
}
