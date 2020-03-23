import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_event.dart';

class OtpInputWidget extends StatelessWidget {
  final String verificationId;

  OtpInputWidget(this.verificationId);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 60,
            child: TextFormField(
              maxLines: 1,
              obscureText: true,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: '******'
              ),
              onChanged: (value) {
                BlocProvider.of<PhoneVerificationBloc>(context)
                    .add(OtpChanged(value));
              },
            ),
          ),
        ),
      ],
    );
  }
}
