import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/home_widget.dart';
import 'package:provider/provider.dart';

import '../../repository/auth_repository.dart';
import '../auth/auth_widget.dart';
import '../profile/profile_widget.dart';
import 'splash_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

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
    return BlocProvider(
      create: (_) => SplashBloc(authRepository)..add(CheckAuthentication()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (_, state) {
          if (state is Authenticated) {
            Navigator.of(context).popAndPushNamed(HomeWidget.route);
          } else if (state is AuthenticationRequired) {
            Navigator.of(context).popAndPushNamed(AuthWidget.route);
          }
        },
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
