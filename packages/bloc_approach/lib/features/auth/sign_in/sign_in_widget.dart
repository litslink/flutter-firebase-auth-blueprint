import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/password_reset/password_reset_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/phone/phone_verification_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_state.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/home_widget.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:provider/provider.dart';

class SignInWidget extends StatelessWidget {
  static final String route = '/sign_in';

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: BlocProvider(
          create: (_) => SignInBloc(authRepository),
          child: BlocConsumer<SignInBloc, SignInState>(
            listener: (context, state) {
              switch (state.runtimeType) {
                case Authenticated:
                  Navigator.of(context).popAndPushNamed(HomeWidget.route);
                  break;

                case PhoneVerificationRedirect:
                  Navigator.of(context).pushNamed(PhoneVerificationWidget.route);
                  break;

                case ResetPasswordRedirect:
                  Navigator.of(context).pushNamed(PasswordResetWidget.route);
                  break;

                case CreateAccountRedirect:
                  Navigator.of(context).popAndPushNamed(SignUpWidget.route);
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
            buildWhen: (_, state) => state is SignInForm || state is Loading,
            // ignore: missing_return
            builder: (context, state) {
              switch (state.runtimeType) {
                case SignInForm:
                  final formState = state as SignInForm;
                  return _buildSignInForm(
                    context,
                    formState.isEmailValid,
                    formState.isPasswordValid
                  );

                case Loading:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm(BuildContext context,
      bool isEmailValid, bool isPasswordValid) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Logo.',
                  style: TextStyle(fontSize: 40),
                ),
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
                    errorText: isEmailValid
                      ? null
                      : 'Invalid email address'
                ),
                onChanged: (value) {
                  BlocProvider.of<SignInBloc>(context).add(
                    EmailChanged(value)
                  );
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
                    errorText: isPasswordValid
                      ? null
                      : 'Password is too short'
                ),
                onChanged: (value) {
                  BlocProvider.of<SignInBloc>(context).add(
                    PasswordChanged(value)
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<SignInBloc>(context).add(
                    ResetPassword()
                  );
                },
                child:Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot your password?',
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 12),
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
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<SignInBloc>(context).add(
                    CreateAccount()
                  );
                },
                child: Text('or create an account',
                    style: TextStyle(fontSize: 16, color: Colors.blue)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionSignInMethod(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            BlocProvider.of<SignInBloc>(context).add(
              SignInWithGoogle()
            );
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
            BlocProvider.of<SignInBloc>(context).add(
              SignInWithPhoneNumber()
            );
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
}
