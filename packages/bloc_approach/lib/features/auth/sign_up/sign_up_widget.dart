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
    final authRepository = Provider.of<AuthRepository>(context);
    return Scaffold(
      body: BlocProvider(
        create: (_) => SignUpBloc(authRepository),
        child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.of(context).popAndPushNamed(HomeWidget.route);
            } else if (state is SignInRedirect) {
              Navigator.of(context)
                  .popAndPushNamed(SignInWidget.route);
            } else if (state is AuthError) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Something went wrong. Check your internet connection'),
                  )
              );
            }
          },
          buildWhen: (_, state) => state is SignUpForm || state is Loading,
          // ignore: missing_return
          builder: (context, state) {
            if (state is SignUpForm) {
              return _buildSignUpForm(context,
                  state.isNameValid, state.isEmailValid,
                  state.isPasswordValid, state.isConfirmPasswordValid);
            } else if (state is Loading) {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

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
              final event = NameChanged(value);
              BlocProvider.of<SignUpBloc>(context).add(event);
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
              final event = EmailChanged(value);
              BlocProvider.of<SignUpBloc>(context).add(event);
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
              final event = PasswordChanged(value);
              BlocProvider.of<SignUpBloc>(context).add(event);
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
              final event = ConfirmPasswordChanged(value);
              BlocProvider.of<SignUpBloc>(context).add(event);
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
                    final event = SignUp();
                    BlocProvider.of<SignUpBloc>(context).add(event);
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
    );
  }
}