import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/profile/preview/profile_model.dart';
import 'package:flutter_firebase_auth_blueprint/features/util/avatar.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  static final String route = '/profile';

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileModel>(
      builder: (key, model, child) {
        Widget view;
        switch (model.state) {
          case ViewState.loading:
            view = Scaffold(body: _buildLoading());
            break;

          case ViewState.userLoaded:
            view = Scaffold(
              appBar: _buildAppBar(model),
              body: _buildProfileScreen(model),
            );
            break;

        }
        return view;
      },
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());

  Widget _buildProfileScreen(ProfileModel model) {
    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Avatar(model.user, 50),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                model.user.displayName ?? 'Unknown',
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
                        child: Text(
                          'Email',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          model.user.email ?? 'Unknown',
                          style: TextStyle(fontSize: 14, color: Colors.black38),
                        )),
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
                        child: Text(
                          'Phone number',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          model.user.phoneNumber == null ||
                                  model.user.phoneNumber.isEmpty
                              ? 'Unknown'
                              : model.user.phoneNumber,
                          style: TextStyle(fontSize: 14, color: Colors.black38),
                        )),
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
                          child: Text(
                            'Notification',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Switch(
                      value: model.isNotificationsEnabled,
                      onChanged: (value) {
                        model.setNotificationsEnabled(value: value);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => model.logOut(),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
            ),
          ),
        )
      ],
    );
  }

  AppBar _buildAppBar(ProfileModel model) {
    return AppBar(
      title: Text(
        'Profile',
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      actions: <Widget>[
        FlatButton(
          onPressed: model.editProfile,
          child: Center(
            child: Text(
              'Edit',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        )
      ],
    );
  }
}
