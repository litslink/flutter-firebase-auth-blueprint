import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_delegate.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_model.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validators.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  static final String route = '/sign_up';

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => SignUpModel(
            authRepository,
            NotEmptyValidator(),
            EmailValidator(),
            PasswordValidator(),
            SignUpDelegateImpl(context)
          ),
          child: Consumer<SignUpModel>(
            // ignore: missing_return
            builder: (_, model, __) {
              switch (model.state) {
                case ViewState.inputForm: return _buildSignUpForm(context, model);
                case ViewState.loading: return _buildLoading();
              }
            },
          ),
        )
      ),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());

  Widget _buildSignUpForm(BuildContext context, SignUpModel model) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Logo.',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Please fill the form to creating account',
                  style: TextStyle(fontSize: 18, color: Colors.black38),
                ),
              ),
            ),
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
                  errorText: model.isNameValid
                    ? null
                    : 'Name can not be empty',
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
                  errorText: model.isEmailValid
                    ? null
                    : 'Invalid email address',
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
                  errorText: model.isPasswordValid
                    ? null
                    : 'Password is too short',
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
                  errorText: model.isConfirmPasswordValid
                    ? null
                    : 'Passwords are not valid',
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      child: Text('Create account', style: TextStyle(fontSize: 16, color: Colors.white)),
                      onPressed: model.signUp,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: model.signIn,
              child: Text('or sign in', style: TextStyle(fontSize: 16, color: Colors.blue)),
            )
          ],
        ),
      ),
    );
  }
}