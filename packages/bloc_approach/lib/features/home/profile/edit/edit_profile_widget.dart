import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/user.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/image_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'edit_profile_bloc.dart';
import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileWidget extends StatefulWidget {
  static final String route = '/edit_profile';

  @override
  State createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileWidget> {

  File _pickedPhoto;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final user = ModalRoute.of(context).settings.arguments as User;
        final authRepository = Provider.of<AuthRepository>(context);
        final imageLoader = Provider.of<ImageManager>(context);
        return EditProfileBloc(user, authRepository, imageLoader);
      },
      child: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (_, state) {
          if (state is EditCompleted) {
            Navigator.of(context).pop();
          }
        },
        buildWhen: (_, state) => state is Loading
            || state is ProfileInfo
            || state is Error,
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
          } else if (state is Error) {
            return Scaffold(
              body: Center(
                child: Text('Something went wrong :('),
              ),
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
                onTap: () async {
                  final result = await ImagePicker
                      .pickImage(source: ImageSource.gallery);
                  final event = PhotoChanged(result);
                  BlocProvider.of<EditProfileBloc>(context).add(event);
                  setState(() {
                    _pickedPhoto = result;
                  });
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
    Widget avatar;
    if (_pickedPhoto != null) {
      avatar = CircleAvatar(
        backgroundImage: FileImage(_pickedPhoto),
        radius: 35,
      );
    } else if (photoUrl != null) {
      avatar = CircleAvatar(
          backgroundImage: NetworkImage(photoUrl),
          radius: 35,
      );
    } else {
      avatar = CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 35,
      );
    }
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
        FlatButton(
          onPressed: () {
            BlocProvider.of<EditProfileBloc>(context).add(ConfirmChanges());
          },
          child: Center(
            child: Text('Done',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        )
      ],
    );
  }
}
