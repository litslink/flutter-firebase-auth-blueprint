import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditProfileWidget extends StatelessWidget {
  static final String route = '/edit_profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: <Widget>[
          GestureDetector(
            onTap: () {

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
      ),
    );
  }
}
