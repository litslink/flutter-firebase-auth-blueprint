import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/new/new_note_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/notes_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/notes_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/note.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/notes_repository.dart';
import 'package:provider/provider.dart';

import 'notes_bloc.dart';

class NotesWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    final notesRepository = Provider.of<NotesRepository>(context);
    return BlocProvider(
      create: (_) => NotesBloc(notesRepository, authRepository),
      child: BlocConsumer<NotesBloc, NotesState>(
        listener: (_, state) {
          if (state is NewNoteRedirect) {
            Navigator.of(context).pushNamed(NewNoteWidget.route);
          }
        },
        buildWhen: (_, state) => !(state is NewNoteRedirect),
        // ignore: missing_return
        builder: (context, state) {
          switch (state.runtimeType) {
            case Content:
              final notes = (state as Content).notes;
              return Scaffold(
                floatingActionButton: _buildFAB(context),
                body: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: notes.length,
                    itemBuilder: (_, index) => _buildListItem(context, notes[index])
                  ),
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
                floatingActionButton: _buildFAB(context),
                body: Center(
                  child: Text('Empty notes. Please, add one'),
                ),
              );

            case Error:
              return Scaffold(
                floatingActionButton: _buildFAB(context),
                body: Center(
                  child: Text('Something went wrong'),
                ),
              );
          }
        },
      ),
    );
  }

  Widget _buildFAB(BuildContext context) => FloatingActionButton(
    onPressed: () {
      BlocProvider.of<NotesBloc>(context).add(
        NewNote()
      );
    },
    child: Icon(Icons.add),
  );

  Widget _buildListItem(BuildContext context, Note note) {
    return Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(note.title,
                    style: TextStyle(fontSize: 20, color: Colors.black),),
                ),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<NotesBloc>(context).add(
                      DeleteNote(note)
                    );
                  },
                  icon: Icon(Icons.delete),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(note.text,
                style: TextStyle(fontSize: 14, color: Colors.black38),
              )
            ),
          )
        ],
      ),
    );
  }
}
