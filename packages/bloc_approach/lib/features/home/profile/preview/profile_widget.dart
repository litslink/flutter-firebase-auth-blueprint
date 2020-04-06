import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/auth/sign_in/sign_in_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/profile/edit/edit_profile_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/util/avatar.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/user.dart';

import 'profile_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileWidget extends StatelessWidget {
  static final String route = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: <Widget>[
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileInfo) {
                return FlatButton(
                  onPressed: () {
                    BlocProvider.of<ProfileBloc>(context).add(
                      EditProfile()
                    );
                  },
                  child: Center(
                    child: Text('Edit',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                );
              } else {
                return Container(height: 0, width: 0);
              }
            },
          )
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (_, state) {
          switch (state.runtimeType) {
            case AuthenticationRequired:
              Navigator.of(context).popAndPushNamed(SignInWidget.route);
              break;
            case EditProfileRedirect:
              final user = (state as EditProfileRedirect).user;
              Navigator.of(context).pushNamed(EditProfileWidget.route, arguments: user);
              break;
          }
        },
        buildWhen: (_, state) => state is Loading || state is ProfileInfo,
        // ignore: missing_return
        builder: (_, state) {
          switch (state.runtimeType) {
            case ProfileInfo:
              final infoState = (state as ProfileInfo);
              return _buildProfileInfo(
                context,
                infoState.user,
                infoState.isNotificationEnabled
              );

            case Loading:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, User user, bool isNotificationEnabled) {
    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Avatar(user, 50),
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
                      child: Text(
                        user.phoneNumber == null || user.phoneNumber.isEmpty
                          ? 'Unknown'
                          : user.phoneNumber,
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
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Notification',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Switch(
                      value: isNotificationEnabled,
                      onChanged: (_) {
                        final bloc = BlocProvider.of<ProfileBloc>(context);
                        if (isNotificationEnabled) {
                          bloc.add(DisableNotification());
                        } else {
                          bloc.add(EnableNotification());
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            BlocProvider.of<ProfileBloc>(context).add(
              SignOut()
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Logout',
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
            ),
          ),
        )
      ],
    );
  }
}
