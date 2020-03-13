import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../model/user.dart';
import '../../../repository/auth_repository.dart';
import 'edit_profile_bloc.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileWidget extends StatelessWidget {
  static final String route = '/edit_profile';

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments as User;
    final authRepository = Provider.of<AuthRepository>(context);
    return BlocProvider(
      create: (_) => EditProfileBloc(user, authRepository),
      child: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (_, state) {
          if (state is EditCompleted) {
            Navigator.of(context).pop(state.containsChanges);
          }
        },
        buildWhen: (_, state) => state == Loading || state == ProfileInfo,
        // ignore: missing_return
        builder: (context, state) {
          if (state is Loading) {
            return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                )
            );
          } else if (state is ProfileInfo) {
            return Scaffold(
                appBar: _buildAppBar(context),
                body: _buildProfileInfo(context, state.user)
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, User user) {
    return ListView(
      children: <Widget>[
        Card(
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {

                },
                child: _buildPhotoPicker(context, user.photoUrl),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: false,
                    decoration: InputDecoration(
                        hintText: 'Name',
                    ),
                    validator: (value) => value.isEmpty
                        ? 'Name can\'t be empty' : null,
                    initialValue: user.displayName,
                    onChanged: (value) {
                      final event = NameChanged(value);
                      BlocProvider.of<EditProfileBloc>(context).add(event);
                    },
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPhotoPicker(BuildContext context, String photoUrl) {
    final avatar = photoUrl != null
        ? CircleAvatar(backgroundImage: NetworkImage(photoUrl), radius: 35)
        : CircleAvatar(backgroundColor: Colors.blue,);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          avatar,
          Icon(Icons.photo_camera, size: 30,)
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Edit Profile',
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            BlocProvider.of<EditProfileBloc>(context).add(ConfirmChanges());
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Done',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          ),
        )
      ],
    );
  }
}
