import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_state.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/home_widget.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:provider/provider.dart';

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
            switch (state.runtimeType) {
              case Authenticated:
                Navigator.of(context).popAndPushNamed(HomeWidget.route);
                break;

              case AuthError:
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Something went wrong. Check your internet connection'
                    ),
                  )
                );
                break;
            }
          },
          buildWhen: (_, state) => state is PhoneInputForm
              || state is OtpInputForm
              || state is Loading,
          // ignore: missing_return
          builder: (_, state) {
            switch (state.runtimeType) {
              case PhoneInputForm:
                return _PhoneInputWidget();

              case OtpInputForm:
                final verificationId = (state as OtpInputForm).verificationId;
                return _OtpInputWidget(verificationId);

              case Loading:
                return Center(
                  child: CircularProgressIndicator(),
                );

              case AuthError:
                return Center(
                  child: Text('Something went wrong'),
                );
            }
          },
        )
      ),
    );
  }
}

class _OtpInputWidget extends StatelessWidget {
  final String verificationId;

  _OtpInputWidget(this.verificationId);

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
                BlocProvider.of<PhoneVerificationBloc>(context).add(
                  OtpChanged(value)
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _PhoneInputWidget extends StatelessWidget {
  final _phoneNumberController = TextEditingController();
  final _phoneFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _phoneFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
            child: TextFormField(
              maxLines: 1,
              autofocus: true,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Phone number',
                icon: Icon(
                  Icons.phone,
                  color: Colors.grey,
                )),
              validator: (value) => value.isEmpty
                ? 'Phone number can\'t be empty'
                : null,
              controller: _phoneNumberController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)
                    ),
                    color: Colors.blue,
                    child: Text('Submit',
                      style: TextStyle(fontSize: 16, color: Colors.white)
                    ),
                    onPressed: () {
                      if (_phoneFormKey.currentState.validate()) {
                        final phoneNumber = _phoneNumberController.text;
                        BlocProvider.of<PhoneVerificationBloc>(context).add(
                          ConfirmPhone(phoneNumber)
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
