import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_up/sign_up_state.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/home_widget.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  static final String route = '/sign_up';

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    return Scaffold(
      body: BlocProvider(
        create: (_) => SignUpBloc(authRepository),
        child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (_, state) {
            if (state is Authenticated) {
              Navigator.of(context).popAndPushNamed(HomeWidget.route);
            } else if (state is SignInRedirect) {
              Navigator.of(context)
                  .popAndPushNamed(SignInWidget.route);
            } else if (state is AuthError) {

            }
          },
          buildWhen: (_, state) => state is SignUpForm || state is Loading,
          // ignore: missing_return
          builder: (context, state) {
            if (state is SignUpForm) {
              return _buildSignUpForm(context);
            } else if (state is Loading) {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
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
                  helperText: ' '
              ),
              validator: (value) => value.isEmpty
                  ? 'Name can\'t be empty' : null,
              controller: _nameController,
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
                  helperText: ' '
              ),
              validator: (value) => _validateEmail(value)
                  ? null
                  : 'Incorrect email form',
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
                  ),
                  helperText: ' '
              ),
              validator: (value) => _validatePassword(value)
                  ? null
                  : 'Password is too short',
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
                  ),
                  helperText: ' '
              ),
              validator: (value) {
                if (value.isEmpty || value != _passwordController.text) {
                  return 'Passwords do not match';
                } else {
                  return null;
                }
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
                      if (_formKey.currentState.validate()) {
                        final event = SignUp(
                          _nameController.text,
                          _emailController.text,
                          _passwordController.text
                        );
                        BlocProvider.of<SignUpBloc>(context).add(event);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              final event = SignIn();
              BlocProvider.of<SignUpBloc>(context).add(event);
            },
            child: Text('or sign in',
                style: TextStyle(fontSize: 16, color: Colors.blue)
            ),
          )
        ],
      ),
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