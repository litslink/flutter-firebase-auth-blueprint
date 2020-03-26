import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/profile/preview/profile_model.dart';
import 'package:flutter_firebase_auth_blueprint/features/profile/preview/profile_router.dart';
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
    final router = ProfileRouterImpl(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        actions: <Widget>[],
      ),
      body: ChangeNotifierProvider(
        create: (context) =>
            ProfileModel(authRepository, settingsRepository, router),
        child: Consumer<ProfileModel>(
          builder: (key, model, child) {
            Widget view;
            switch (model.state) {
              case ViewState.loading:
                view = _buildLoading();
                model.loadUserInfo();
                break;
              case ViewState.userLoaded:
                view = _buildProfileScreen(
                    context, model, model.isNotificationsEnabled);
                break;
              case ViewState.signOut:
                view = _buildLoading();
                break;
            }
            return view;
          },
        ),
      ),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());

  Widget _buildProfileScreen(
      BuildContext context, ProfileModel model, bool isNotificationsEnabled) {
    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: _buildAvatar(model.user),
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
                      value: isNotificationsEnabled,
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

  Widget _buildAvatar(User user) {
    if (user.photoUrl != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(user.photoUrl),
        radius: 50,
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
