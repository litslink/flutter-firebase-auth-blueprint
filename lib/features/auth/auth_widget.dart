import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../repository/auth_repository.dart';
import '../profile/profile_widget.dart';

import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

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
            Navigator.of(context).popAndPushNamed(ProfileWidget.route);
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
          _buildGoogleSignInButton(context),
          _buildClickableText('or create an account', () {
            setState(() {
              _type = _AuthType.signUp;
            });
          })
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
          _buildGoogleSignInButton(context),
          _buildClickableText('or sign in', () {
            setState(() {
              _type = _AuthType.signIn;
            });
          })
        ],
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
              ),
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.search, color: Colors.white,),
                  Text('Sign in with google',
                      style: TextStyle(fontSize: 16, color: Colors.white)
                  ),
                ],
              ),
              onPressed: () {
                final event = SignInWithGoogle();
                BlocProvider.of<AuthBloc>(context).add(event);
              },
            ),
          ),
        ],
      ),
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
              child: Text('Create account',
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
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableText(String text, Function onTap) {
    return GestureDetector(
      onTap: () => onTap,
      child: Text(text, style: TextStyle(fontSize: 16, color: Colors.black38)
      ),
    );
  }
}
