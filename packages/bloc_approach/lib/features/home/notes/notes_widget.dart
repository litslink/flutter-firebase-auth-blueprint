import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/notes/mini_profile_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/notes/new_note_widget.dart';
import 'package:flutter_firebase_auth_blueprint/features/home/notes/notes_state.dart';
import 'package:flutter_firebase_auth_blueprint/features/util/avatar.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/note.dart';

import 'notes_bloc.dart';
import 'notes_event.dart';

class NotesWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      // ignore: missing_return
      builder: (context, state) {
        switch (state.runtimeType) {
          case Content:
            final notes = (state as Content).notes;
            return Scaffold(
              appBar: _buildAppBar(),
              floatingActionButton: _buildFAB(context),
              body: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: notes.length,
                itemBuilder: (_, index) => _buildListItem(context, notes[index])
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
              appBar: _buildAppBar(),
              floatingActionButton: _buildFAB(context),
              body: Center(
                child: Text('Empty notes. Please, add one'),
              ),
            );

          case Error:
            return Scaffold(
              appBar: _buildAppBar(),
              floatingActionButton: _buildFAB(context),
              body: Center(
                child: Text('Something went wrong'),
              ),
            );
        }
      },
    );
  }

  AppBar _buildAppBar() {
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
          child: BlocBuilder<MiniProfileBloc, MiniProfileState>(
            // ignore: missing_return
            builder: (_, state) {
              switch (state.runtimeType) {
                case ProfileInfo:
                  final user = (state as ProfileInfo).user;
                  return Avatar(user, 20);

                case EmptyUser:
                  return Container();
              }
            },
          )
        ),
      ],
    );
  }

  Widget _buildFAB(BuildContext context) => FloatingActionButton(
    onPressed: () async {
      final note = await Navigator.of(context).pushNamed(NewNoteWidget.route) as Note;
      if (note != null) {
        BlocProvider.of<NotesBloc>(context).add(
          NewNote(note)
        );
      }
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
                  child: Text(
                    note.title,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<NotesBloc>(context).add(
                      DeleteNote(note)
                    );
                  },
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
