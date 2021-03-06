import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/password_reset/password_reset_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/password_reset/password_reset_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/password_reset/password_reset_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:provider/provider.dart';

class PasswordResetWidget extends StatelessWidget {
  static final String route = '/password_reset';

  final _emailController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reset password',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: BlocProvider(
        create: (_) {
          final authRepository = Provider.of<AuthRepository>(context);
          return PasswordResetBloc(authRepository);
        },
        child: BlocConsumer<PasswordResetBloc, PasswordResetState>(
          listener: (_, state) {
            if (state is AuthError) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Something went wrong. Check your internet connection'
                    ),
                  )
              );
            }
          },
          buildWhen: (_, state) => state is EmailInputForm
              || state is Loading
              || state is ResetInstructionsDelivered,
          // ignore: missing_return
          builder: (context, state) {
            switch (state.runtimeType) {
              case EmailInputForm:
                return _buildEmailInputForm(context);

              case Loading:
                return Center(
                  child: CircularProgressIndicator(),
                );

              case ResetInstructionsDelivered:
                return _buildConfirmation();
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmailInputForm(BuildContext context) {
    return Form(
      key: _emailFormKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
            child: TextFormField(
              maxLines: 1,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                icon: Icon(
                  Icons.phone,
                  color: Colors.grey,
                )
              ),
              validator: (value) => value.isEmpty
                ? 'Email can\'t be empty'
                : null,
              controller: _emailController,
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
                    child: Text('Submit',
                      style: TextStyle(fontSize: 16, color: Colors.white)
                    ),
                    onPressed: () {
                      if (_emailFormKey.currentState.validate()) {
                        final email = _emailController.text;
                        BlocProvider.of<PasswordResetBloc>(context).add(
                          SubmitEmail(email)
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildConfirmation() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Icon(Icons.done, size: 24),
          ),
          Text('Please check your email',
            style: TextStyle(fontSize: 16, color: Colors.black38)
          )
        ],
      ),
    );
  }
}
