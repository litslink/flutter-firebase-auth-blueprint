import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/notes_delegate.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/notes_model.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/note.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/notes_repository.dart';
import 'package:provider/provider.dart';

class NotesWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final notesRepository = Provider.of<NotesRepository>(context);
    final authRepository = Provider.of<AuthRepository>(context);
    return ChangeNotifierProvider(
      create: (_) => NotesModel(
        notesRepository,
        authRepository,
        NotesDelegateImpl(context)
      ),
      child: Consumer<NotesModel>(
        // ignore: missing_return
        builder: (_, model, __) {
          switch (model.state.runtimeType) {
            case Content:
              final notes = (model.state as Content).notes;
              return Scaffold(
                floatingActionButton: _buildFAB(model),
                body: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: notes.length,
                    itemBuilder: (_, index) => _buildListItem(model, notes[index])
                  ),
                ),
              );
            case Loading: return Scaffold(
              body: Center(
                child: CircularProgressIndicator()
              )
            );
            case Empty: return Scaffold(
              floatingActionButton: _buildFAB(model),
              body: Center(
                child: Text('Empty notes. Please, add one'),
              ),
            );
          }
        },
      )
    );
  }

  Widget _buildFAB(NotesModel model) => FloatingActionButton(
    onPressed: model.addNote,
    child: Icon(Icons.add),
  );

  Widget _buildListItem(NotesModel model, Note note) {
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(note.title, style: TextStyle(fontSize: 20, color: Colors.black),),
                ),
                IconButton(
                  onPressed: () => model.deleteNote(note),
                  icon: Icon(Icons.delete),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(note.text, style: TextStyle(fontSize: 14, color: Colors.black38),)
            ),
          )
        ],
      ),
    );
  }
}
