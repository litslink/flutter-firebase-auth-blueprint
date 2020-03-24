import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/user.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/settings_repository.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {

  static final String route = '/profile';

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    final settingsRepository = Provider.of<SettingsRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: <Widget>[

        ],
      ),
      body: null
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}

// ignore: must_be_immutable
class _ProfileInfoWidget extends StatefulWidget {
  final User user;
  bool isNotificationEnabled;

  // ignore: avoid_positional_boolean_parameters
  _ProfileInfoWidget(this.user, this.isNotificationEnabled);

  @override
  State createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<_ProfileInfoWidget> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: _buildAvatar(widget.user),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.user.displayName ?? 'Unknown',
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
                        child: Text(widget.user.email ?? 'Unknown',
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
                          widget.user.phoneNumber == null
                              || widget.user.phoneNumber.isEmpty
                              ? 'Unknown'
                              : widget.user.phoneNumber,
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
                      value: widget.isNotificationEnabled,
                      onChanged: (value) {
                        setState(() {
                          widget.isNotificationEnabled = !widget
                              .isNotificationEnabled;

                        });
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
