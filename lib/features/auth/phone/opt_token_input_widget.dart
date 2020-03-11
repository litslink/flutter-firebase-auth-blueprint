import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_bloc.dart';
import '../auth_event.dart';

class OtpTokenInputWidget extends StatelessWidget {
  final String verificationId;

  OtpTokenInputWidget(this.verificationId);

  final _tokenController = TextEditingController();
  final _tokenFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _tokenFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: TextFormField(
                maxLines: 1,
                obscureText: true,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Token',
                    icon: Icon(
                      Icons.phone,
                      color: Colors.grey,
                    )),
                validator: (value) => value.isEmpty
                    ? 'Otp token can\'t be empty' : null,
                controller: _tokenController,
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
                        if (_tokenFormKey.currentState.validate()) {
                          final smsCode = _tokenController.text;
                          BlocProvider.of<AuthBloc>(context)
                              .add(SignInWithPhone(verificationId, smsCode));
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
