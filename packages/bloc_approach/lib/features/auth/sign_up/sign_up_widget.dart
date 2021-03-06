import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_state.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/home_widget.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  static final String route = '/sign_up';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: BlocProvider(
          create: (_) {
            final authRepository = Provider.of<AuthRepository>(context);
            return SignUpBloc(authRepository);
          },
          child: BlocConsumer<SignUpBloc, SignUpState>(
            listener: (context, state) {
              switch (state.runtimeType) {
                case Authenticated:
                  Navigator.of(context).popAndPushNamed(HomeWidget.route);
                  break;

                case SignInRedirect:
                  Navigator.of(context).popAndPushNamed(SignInWidget.route);
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
            buildWhen: (_, state) => state is SignUpForm || state is Loading,
            // ignore: missing_return
            builder: (context, state) {
              switch (state.runtimeType) {
                case SignUpForm:
                  final formState = state as SignUpForm;
                  return _buildSignUpForm(
                    context,
                    formState.isNameValid,
                    formState.isEmailValid,
                    formState.isPasswordValid,
                    formState.isConfirmPasswordValid
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

  Widget _buildSignUpForm(
    BuildContext context,
    bool isNameValid,
    bool isEmailValid,
    bool isPasswordValid,
    bool isConfirmPasswordValid) {
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
                  errorText: isNameValid
                    ? null
                    : 'Name can not be empty',
                ),
                onChanged: (value) {
                  BlocProvider.of<SignUpBloc>(context).add(
                    NameChanged(value)
                  );
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
                  errorText: isEmailValid
                    ? null
                    : 'Invalid email address',
                ),
                onChanged: (value) {
                  BlocProvider.of<SignUpBloc>(context).add(
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
                    : 'Password is too short',
                ),
                onChanged: (value) {
                  BlocProvider.of<SignUpBloc>(context).add(
                    PasswordChanged(value)
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
                  hintText: 'Confirm password',
                  icon: Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
                  helperText: ' ',
                  errorText: isConfirmPasswordValid
                    ? null
                    : 'Passwords are not valid',
                ),
                onChanged: (value) {
                  BlocProvider.of<SignUpBloc>(context).add(
                    ConfirmPasswordChanged(value)
                  );
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
                        BlocProvider.of<SignUpBloc>(context).add(
                          SignUp()
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: GestureDetector(
                onTap: () {
                  BlocProvider.of<SignUpBloc>(context).add(
                    SignIn()
                  );
                },
                child: Text('or sign in',
                  style: TextStyle(fontSize: 16, color: Colors.blue)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}