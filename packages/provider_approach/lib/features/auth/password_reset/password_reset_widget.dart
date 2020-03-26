import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/password_reset/password_reset_delegate.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/password_reset/password_reset_model.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validators.dart';
import 'package:provider/provider.dart';

class PasswordResetWidget extends StatelessWidget {
  static final String route = '/password_reset';

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    return ChangeNotifierProvider(
      create: (_) => PasswordResetModel(
        authRepository,
        EmailValidator(),
        PasswordResetDelegateImpl(context)
      ),
      child: Consumer<PasswordResetModel>(
        builder: (_, model, __) {
          Widget view;
          switch (model.state) {
            case ViewState.inputForm:
              view = _buildEmailInputForm(model);
              break;
            case ViewState.loading:
              view = _buildLoading();
              break;
            case ViewState.done:
              view = _buildConfirmation();
              break;
          }
          return Scaffold(
            appBar: AppBar(
              title: Text('Reset password'),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: model.cancel,
                )
              ],
            ),
            body: view,
          );
        }
      ),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());

  Widget _buildEmailInputForm(PasswordResetModel model) {
    return Column(
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
              ),
              errorText: model.isEmailValid ? null : 'Email can\'t be empty'
            ),
            onChanged: model.emailChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  color: Colors.blue,
                  child: Text('Submit', style: TextStyle(fontSize: 16, color: Colors.white)),
                  onPressed: model.submitEmail,
                ),
              ),
            ],
          ),
        )
      ],
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
