import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  static final String route = '/sign_up';

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    return Scaffold(
      body: null
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());

  Widget _buildSignUpForm(BuildContext context,
      bool isNameValid, bool isEmailValid,
      bool isPasswordValid, bool isConfirmPasswordValid) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: InputDecoration(
                hintText: 'Name',
                icon: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
                helperText: ' ',
                errorText: isNameValid ? null : 'Name can not be empty',
            ),
            onChanged: (value) {

            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            decoration: InputDecoration(
                hintText: 'Email',
                icon: Icon(
                  Icons.mail,
                  color: Colors.grey,
                ),
                helperText: ' ',
                errorText: isEmailValid ? null : 'Invalid email address',
            ),
            onChanged: (value) {

            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: TextFormField(
            maxLines: 1,
            obscureText: true,
            autofocus: false,
            decoration: InputDecoration(
                hintText: 'Password',
                icon: Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                helperText: ' ',
                errorText: isPasswordValid ? null : 'Password is too short',
            ),
            onChanged: (value) {

            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: TextFormField(
            maxLines: 1,
            obscureText: true,
            autofocus: false,
            decoration: InputDecoration(
                hintText: 'Confirm password',
                icon: Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
                helperText: ' ',
                errorText: isConfirmPasswordValid
                    ? null : 'Passwords are not valid',
            ),
            onChanged: (value) {

            },
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
                  child: Text('Create account',
                      style: TextStyle(fontSize: 16, color: Colors.white)
                  ),
                  onPressed: () {

                  },
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {

          },
          child: Text('or sign in',
              style: TextStyle(fontSize: 16, color: Colors.blue)
          ),
        )
      ],
    );
  }
}