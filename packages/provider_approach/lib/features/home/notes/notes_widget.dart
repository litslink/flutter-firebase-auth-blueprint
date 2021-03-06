import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/util/avatar.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/note.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/user.dart';
import 'package:provider/provider.dart';

import 'notes_model.dart';

class NotesWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesModel>(
      // ignore: missing_return
      builder: (_, model, __) {
        switch (model.state.runtimeType) {
          case Content:
            final notes = (model.state as Content).notes;
            return Scaffold(
              appBar: _buildAppBar(model.user),
              floatingActionButton: _buildFAB(model),
              body: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: notes.length,
                itemBuilder: (_, index) => _buildListItem(model, notes[index])
              ),
            );
          case Loading:
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator()
              )
            );
          case Empty:
            return Scaffold(
              appBar: _buildAppBar(model.user),
              floatingActionButton: _buildFAB(model),
              body: Center(
                child: Text('Empty notes. Please, add one'),
              ),
            );
          case Error:
            return Scaffold(
              appBar: _buildAppBar(model.user),
              floatingActionButton: _buildFAB(model),
              body: Center(
                child: Text('Something went wrong'),
              ),
            );
        }
      },
    );
  }

  Widget _buildFAB(NotesModel model) => FloatingActionButton(
    onPressed: model.addNote,
    child: Icon(Icons.add),
  );

  AppBar _buildAppBar(User user) {
    return AppBar(
      title: Text(
        'Notes',
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.all(8),
          child: Avatar(user, 20)
        ),
      ],
    );
  }

  Widget _buildListItem(NotesModel model, Note note) {
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    note.title,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                IconButton(
                  onPressed: () => model.deleteNote(note),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.black38,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                note.text,
                style: TextStyle(fontSize: 14, color: Colors.black38),
              ),
            ),
          )
        ],
      ),
    );
  }
}
