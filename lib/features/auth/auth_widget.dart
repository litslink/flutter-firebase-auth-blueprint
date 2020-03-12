import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../repository/auth_repository.dart';
import '../home/home_widget.dart';
import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'password_reset/password_reset_widget.dart';
import 'phone/phone_verification_widget.dart';

enum _AuthType { signIn, signUp }

class AuthWidget extends StatefulWidget {

  static final String route = '/auth';

  @override
  State createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  _AuthType _type = _AuthType.signIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSingInScreen(context),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Widget _buildSingInScreen(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    return BlocProvider(
      create: (_) => AuthBloc(authRepository),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthSuccessful) {
            Navigator.of(context).popAndPushNamed(HomeWidget.route);
          }
        },
        buildWhen: (_, state) => !(state is AuthSuccessful),
        // ignore: missing_return
        builder: (context, state) {
          if (state is Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AuthRequired) {
            if (_type == _AuthType.signIn) {
              return _buildSignInForm(context);
            } else if (_type == _AuthType.signUp) {
              return _buildSignUpForm(context);
            }
          }
        },
      ),
    );
  }

  Widget _buildSignInForm(BuildContext context) {
    return Form(
      key: _signInFormKey,
      child: Column(
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
                  )),
              validator: (value) => value.isEmpty
                  ? 'Email can\'t be empty' : null,
              controller: _emailController,
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
                  )),
              validator: (value) => value.isEmpty
                  ? 'Password can\'t be empty' : null,
              controller: _passwordController,
            ),
          ),
          _buildPrimaryButton(
            content: Text('Sign in',
                style: TextStyle(fontSize: 16, color: Colors.white)
            ),
            onPressed: () {
              if (_signInFormKey.currentState.validate()) {
                final event = SignIn(
                    _emailController.text,
                    _passwordController.text
                );
                BlocProvider.of<AuthBloc>(context).add(event);
              }
            }
          ),
          _buildAdditionSignInMethod(context),
          GestureDetector(
            onTap: () {
              setState(() {
                _type = _AuthType.signUp;
              });
            },
            child: Text('or create an account',
                style: TextStyle(fontSize: 16, color: Colors.blue)
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(PasswordResetWidget.route);
              },
              child:Text('Forgot your password?',
                  style: TextStyle(fontSize: 14, color: Colors.black38)
              ),
            )
          )
        ],
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  )),
              validator: (value) => value.isEmpty
                  ? 'Email can\'t be empty' : null,
              controller: _emailController,
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
                  )),
              validator: (value) => value.isEmpty
                  ? 'Password can\'t be empty' : null,
              controller: _passwordController,
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
                  )),
              validator: (value) {
                if (value.isEmpty || value != _passwordController.text) {
                  return 'Passwords do not match';
                } else {
                  return null;
                }
              },
            ),
          ),
          _buildPrimaryButton(
              content: Text('Create account',
                  style: TextStyle(fontSize: 16, color: Colors.white)
              ),
              onPressed: () {
                if (_signUpFormKey.currentState.validate()) {
                  final event = SignUp(
                      _emailController.text,
                      _passwordController.text
                  );
                  BlocProvider.of<AuthBloc>(context).add(event);
                }
              }
          ),
          _buildAdditionSignInMethod(context),
          GestureDetector(
            onTap: () {
              setState(() {
                _type = _AuthType.signIn;
              });
            },
            child: Text('or sign in',
                style: TextStyle(fontSize: 16, color: Colors.blue)
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAdditionSignInMethod(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            final event = SignInWithGoogle();
            BlocProvider.of<AuthBloc>(context).add(event);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 40,
                height: 40,
                child: Image.network('https://cdn4.iconfinder.com/data/icons/new-google-logo-2015/400/new-google-favicon-512.png')
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
                child: Image.network('https://image.flaticon.com/icons/png/512/124/124010.png')
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(PhoneVerificationWidget.route);
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

  Widget _buildPrimaryButton({Widget content, Function onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
              ),
              color: Colors.blue,
              child: content,
              onPressed: () => onPressed(),
            ),
          ),
        ],
      ),
    );
  }
}
