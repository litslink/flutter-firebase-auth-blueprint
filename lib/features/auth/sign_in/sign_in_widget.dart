import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/password_reset/password_reset_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_state.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/home_widget.dart';
import 'package:provider/provider.dart';

class SignInWidget extends StatelessWidget {
  static final String route = '/sign_in';

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    return Scaffold(
      body: BlocProvider(
        create: (_) => SignInBloc(authRepository),
        child: BlocConsumer<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.of(context).popAndPushNamed(HomeWidget.route);
            } else if (state is PhoneVerificationRedirect) {
              Navigator.of(context)
                  .popAndPushNamed(PhoneVerificationWidget.route);
            } else if (state is ResetPasswordRedirect) {
              Navigator.of(context).pushNamed(PasswordResetWidget.route);
            } else if (state is CreateAccountRedirect) {
              Navigator.of(context)
                  .popAndPushNamed(SignUpWidget.route);
            } else if (state is AuthError) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Something went wrong. Check your internet connection'),
                  )
              );
            }
          },
          buildWhen: (_, state) => state is SignInForm || state is Loading,
          // ignore: missing_return
          builder: (context, state) {
            if (state is SignInForm) {
              return _buildSignInForm(
                  context, state.isEmailValid, state.isPasswordValid);
            } else if (state is Loading) {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildSignInForm(BuildContext context,
      bool isEmailValid, bool isPasswordValid) {
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
                errorText: isEmailValid ? null : 'Invalid email address'
            ),
            onChanged: (value) {
              BlocProvider.of<SignInBloc>(context).add(EmailChanged(value));
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
                errorText: isPasswordValid ? null : 'Password is too short'
            ),
            onChanged: (value) {
              BlocProvider.of<SignInBloc>(context).add(PasswordChanged(value));
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
                  child: Text('Sign in',
                      style: TextStyle(fontSize: 16, color: Colors.white)
                  ),
                  onPressed: () {
                    BlocProvider.of<SignInBloc>(context).add(SignIn());
                  },
                ),
              ),
            ],
          ),
        ),
        _buildAdditionSignInMethod(context),
        GestureDetector(
          onTap: () {
            final event = CreateAccount();
            BlocProvider.of<SignInBloc>(context).add(event);
          },
          child: Text('or create an account',
              style: TextStyle(fontSize: 16, color: Colors.blue)
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                final event = ResetPassword();
                BlocProvider.of<SignInBloc>(context).add(event);
              },
              child:Text('Forgot your password?',
                  style: TextStyle(fontSize: 14, color: Colors.black38)
              ),
            )
        )
      ],
    );
  }

  Widget _buildAdditionSignInMethod(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            final event = SignInWithGoogle();
            BlocProvider.of<SignInBloc>(context).add(event);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset('assets/images/google-image.png')
            ),
          ),
        ),
        GestureDetector(
          onTap: () {

          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset('assets/images/facebook-image.png')
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            final event = SignInWithPhoneNumber();
            BlocProvider.of<SignInBloc>(context).add(event);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.phone_android, size: 40,)
            ),
          ),
        )
      ],
    );
  }

  bool _validateEmail(String email) {
    return RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
    ).hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length > 8;
  }
}
