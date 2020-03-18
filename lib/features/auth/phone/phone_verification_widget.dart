import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/opt_input_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_input_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_state.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/home_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/repository/auth_repository.dart';

class PhoneVerificationWidget extends StatelessWidget {
  static final String route = '/phone_verification';

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    return Scaffold(
      body: BlocProvider(
        create: (_) => PhoneVerificationBloc(authRepository),
        child: BlocConsumer<PhoneVerificationBloc, PhoneVerificationState>(
          listener: (_, state) {
            if (state is Authenticated) {
              Navigator.of(context).popAndPushNamed(HomeWidget.route);
            } else if (state is AuthError) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Something went wrong. Check your internet connection'),
                  )
              );
            }
          },
          buildWhen: (_, state) => state is PhoneInputForm
              || state is OtpInputForm
              || state is Loading,
          // ignore: missing_return
          builder: (_, state) {
            if (state is PhoneInputForm) {
              return PhoneInputWidget();
            } else if (state is OtpInputForm) {
              return OtpInputWidget(state.verificationId);
            } else if (state is Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AuthError) {
              return Center(
                child: Text('Something went wrong :('),
              );
            }
          },
        )
      ),
    );
  }
}
