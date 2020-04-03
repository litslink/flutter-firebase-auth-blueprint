import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/note.dart';

class NewNoteWidget extends StatefulWidget {
  static final String route = '/new_note';

  @override
  State<StatefulWidget> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNoteWidget> {
  String _title = '';
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              final note = Note(null, _title, _text);
              Navigator.of(context).pop(note);
            },
            child: Center(
              child: Text('Save',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (value) {
                _title = value;
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
                _text = value;
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
}
