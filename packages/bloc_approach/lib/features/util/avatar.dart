import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/user.dart';

class Avatar extends StatelessWidget {
  final User _user;
  final double size;

  Avatar(this._user, this.size);

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Container();
    }

    if (_user.photoUrl != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(_user.photoUrl),
        radius: size,
      );
    } else {
      return CircleAvatar(
        child: Text(provideInitial(_user)),
        radius: size,
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
