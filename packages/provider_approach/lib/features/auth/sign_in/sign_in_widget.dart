import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/password_reset/password_reset_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_model.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_router.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_widget.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validators.dart';
import 'package:provider/provider.dart';

class SignInWidget extends StatelessWidget {
  static final String route = '/sign_in';

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    final router = SignInRouterImpl(context);
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => SignInModel(
          authRepository,
          EmailValidator(),
          PasswordValidator(),
          router
        ),
        child: Consumer<SignInModel>(
          builder: (_, model, __) {
            Widget view;
            switch (model.state) {
              case ViewState.inputForm:
                view = _buildSignInForm(context, model);
                break;
              case ViewState.loading:
                view = Center(child: CircularProgressIndicator());
                break;
            }
            return view;
          },
        ),
      ),
    );
  }

  Widget _buildSignInForm(BuildContext context, SignInModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
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
              errorText: model.isEmailValid ? null : 'Invalid email address'),
            onChanged: model.emailChanged,
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
              errorText: model.isPasswordValid ? null : 'Password is too short'
            ),
            onChanged: model.passwordChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.blue,
                  child: Text('Sign in',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                  onPressed: model.signIn,
                ),
              ),
            ],
          ),
        ),
        _buildAdditionSignInMethod(context, model),
        GestureDetector(
          onTap: () {
            Navigator.of(context).popAndPushNamed(SignUpWidget.route);
          },
          child: Text('or create an account',
              style: TextStyle(fontSize: 16, color: Colors.blue)),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(PasswordResetWidget.route);
              },
              child: Text('Forgot your password?', style: TextStyle(fontSize: 14, color: Colors.black38)),
            ))
      ],
    );
  }

  Widget _buildAdditionSignInMethod(BuildContext context, SignInModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: model.signInWithGoogle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/images/google-image.png')),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/images/facebook-image.png')),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).popAndPushNamed(PhoneVerificationWidget.route);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.phone_android,
                size: 40,
              )
            ),
          ),
        )
      ],
    );
  }
}
