import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/profile/edit/edit_profile_delegate.dart';
import 'package:flutter_firebase_auth_blueprint/features/profile/edit/edit_profile_model.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/image_manager.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/validation/validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileWidget extends StatelessWidget {
  static final String route = '/edit_profile';

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    final imageManager = Provider.of<ImageManager>(context);
    final editProfileModel = EditProfileModel(authRepository,
        EditProfileDelegateImpl(context), imageManager, NameValidator());
    return Scaffold(
      appBar: _buildAppBar(context, editProfileModel),
      body: ChangeNotifierProvider(
        create: (context) => editProfileModel,
        child: Consumer<EditProfileModel>(
          builder: (key, model, child) {
            Widget view;
            switch (model.state) {
              case ViewState.userLoaded:
                view = _buildProfileInfo(context, editProfileModel);
                break;
              case ViewState.loading:
                view = _buildLoading();
                model.loadUserInfo();
                break;
            }
            return view;
          },
        ),
      ),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());

  Widget _buildProfileInfo(BuildContext context, EditProfileModel model) {
    return ListView(
      children: <Widget>[
        Card(
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  final result =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  if (result != null) {
                    model.pickPhoto(result);
                  }
                },
                child: _buildPhotoPicker(context, model),
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
                        errorText: model.isNewNameValid
                            ? null
                            : 'Name can\'t be empty'),
                    initialValue: model.user.displayName,
                    onChanged: model.nameChanged,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPhotoPicker(BuildContext context, EditProfileModel model) {
    Widget avatar;
    if (model.pickedPhoto != null) {
      avatar = CircleAvatar(
        backgroundImage: FileImage(model.pickedPhoto),
        radius: 35,
      );
    } else if (model.user.photoUrl != null) {
      avatar = CircleAvatar(
        backgroundImage: NetworkImage(model.user.photoUrl),
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
          Icon(
            Icons.photo_camera,
            size: 30,
          )
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, EditProfileModel model) {
    return AppBar(
      title: Text(
        'Edit Profile',
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      actions: <Widget>[
        FlatButton(
          onPressed: () => model.updateUserProfile(),
          child: Center(
            child: Text(
              'Done',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        )
      ],
    );
  }
}
