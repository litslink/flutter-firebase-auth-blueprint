import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../repository/auth_repository.dart';
import '../profile/profile_widget.dart';

import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthWidget extends StatelessWidget {

  static final String route = '/auth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSingInScreen(context),
    );
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
            return _buildSignInControl(context);
          }
        },
      ),
    );
  }

  Widget _buildSignInControl(BuildContext context) {
    String email;
    String password;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: _buildEmailInput((value) {
            email = value;
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: _buildPasswordInput((value) {
            password = value;
          }),
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
                  onPressed: () {
                    final event = SignUp(email, password);
                    BlocProvider.of<AuthBloc>(context).add(event);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailInput(Function(String) valueChangeListener) {
    return TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
          hintText: 'Email',
          icon: Icon(
            Icons.mail,
            color: Colors.grey,
          )),
      validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
      onChanged: (value) => valueChangeListener(value.trim()),
    );
  }

  Widget _buildPasswordInput(Function(String) valueChangeListener) {
    return TextFormField(
      maxLines: 1,
      obscureText: true,
      autofocus: false,
      decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          )),
      validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
      onChanged: (value) => valueChangeListener(value.trim()),
    );
  }
}
