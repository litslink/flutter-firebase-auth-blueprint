import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../data/repository/auth_repository.dart';
import '../auth_bloc.dart';
import '../auth_event.dart';
import '../auth_state.dart';

class PasswordResetWidget extends StatelessWidget {
  static final String route = '/password_reset';

  final _emailController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    return BlocProvider(
      create: (_) => AuthBloc(authRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reset password'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          // ignore: missing_return
          builder: (context, state) {
            if (state is Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PasswordResetStarted) {
              return _buildConfirmation();
            } else if (state is AuthRequired) {
              return _buildEmailInputForm(context);
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
        mainAxisAlignment: MainAxisAlignment.center,
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
                  )),
              validator: (value) => value.isEmpty
                  ? 'Email can\'t be empty' : null,
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
                        BlocProvider.of<AuthBloc>(context)
                            .add(ResetPassword(email));
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
