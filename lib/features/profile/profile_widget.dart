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
        buildWhen: (_, state) => state is Loading || state is ProfileInfo,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: _buildAvatar(user),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(user.displayName ?? 'Unknown',
                style: TextStyle(fontSize: 24),
              ),
            )
          ],
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Email',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(user.email ?? 'Unknown',
                          style: TextStyle(fontSize: 14, color: Colors.black38),
                        )
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Phone number',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(user.phoneNumber ?? 'Unknown',
                          style: TextStyle(fontSize: 14, color: Colors.black38),
                        )
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            BlocProvider.of<ProfileBloc>(context).add(SignOut());
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Logout',
              style: TextStyle(fontSize: 20, color: Colors.black38),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildAvatar(User user) {
    if (user.photoUrl != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(user.photoUrl), radius: 50,
      );
    } else {
      return CircleAvatar(
        child: Text(provideInitial(user)),
        radius: 50,
      );
    }
  }

  String provideInitial(User user) {
    if (user.displayName != null && user.displayName.isNotEmpty) {
      return user.displayName[0];
    } else if (user.email != null && user.email.isNotEmpty) {
      return user.email[0];
    } else {
      return '';
    }
  }
}
