import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

              },
            ),
          ),
        ),
      ],
    );
  }
}
