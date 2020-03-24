import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PhoneInputWidget extends StatelessWidget {
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
                  ? 'Phone number can\'t be empty' : null,
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
