import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../repository/auth_repository.dart';
import '../auth/auth_widget.dart';
import 'profile_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileWidget extends StatelessWidget {

  static final String route = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildProfileScreen(context),
    );
  }

  Widget _buildProfileScreen(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    return BlocProvider(
      create: (_) => ProfileBloc(authRepository)..add(FetchProfileInfo()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (_, state) {
          if (state is AuthenticationRequired) {
            Navigator.of(context).popAndPushNamed(AuthWidget.route);
          }
        },
        buildWhen: (_, state) => !(state is AuthenticationRequired),
        // ignore: missing_return
        builder: (context, state) {
          if (state is Loading) {
            return Center(child: CircularProgressIndicator(),);
          } else if (state is ProfileInfo) {
            return _buildProfileInfo(context, state.user);
          }
        },
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, User user) {
    return ListView(
      children: <Widget>[
        Text(user.toString()),
        RaisedButton(
          child: Text('Logout'),
          onPressed: () {
            BlocProvider.of<ProfileBloc>(context).add(SignOut());
          },
        )
      ],
    );
  }
}
