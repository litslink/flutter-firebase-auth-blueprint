import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NewNoteWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

  }

  Widget _buildInputForm(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) {

              },
              textInputAction: TextInputAction.next,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700),
              decoration: InputDecoration.collapsed(
                hintText: 'Title',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 32,
                  fontWeight: FontWeight.w700),
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) {

              },
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              decoration: InputDecoration.collapsed(
                hintText: 'Text',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('New note',
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      iconTheme: IconThemeData(
        color: Colors.black
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        FlatButton(
          onPressed: () {

          },
          child: Center(
            child: Text('Save',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        )
      ],
    );
  }
}
