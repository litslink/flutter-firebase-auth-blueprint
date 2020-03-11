import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../repository/auth_repository.dart';
import '../../profile/profile_widget.dart';
import '../auth_bloc.dart';
import '../auth_state.dart';
import 'opt_token_input_widget.dart';
import 'phone_input_widget.dart';

class PhoneVerificationWidget extends StatelessWidget {
  static final String route = '/phone_verification';

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    return BlocProvider(
      create: (_) => AuthBloc(authRepository),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthSuccessful) {
            Navigator.of(context).popAndPushNamed(ProfileWidget.route);
          }
        },
        buildWhen: (_, state) => state is Loading
            || state is PhoneVerificationStarted
            || state is AuthRequired ,
        // ignore: missing_return
        builder: (_, state) {
          if (state is Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PhoneVerificationStarted) {
            final verificationId = state.verificationId;
            return OtpTokenInputWidget(verificationId);
          } else if (state is AuthRequired) {
            return PhoneInputWidget();
          }
        },
      ),
    );
  }
}
