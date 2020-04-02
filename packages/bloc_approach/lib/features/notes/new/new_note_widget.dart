import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/new/new_note_event.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/new/new_note_state.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/notes_repository.dart';
import 'package:provider/provider.dart';

import 'new_note_bloc.dart';

class NewNoteWidget extends StatelessWidget {
  static final String route = '/new_note';

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);
    final notesRepository = Provider.of<NotesRepository>(context);
    return BlocProvider(
      create: (_) => NewNoteBloc(
        authRepository,
        notesRepository
      ),
      child: BlocConsumer<NewNoteBloc, NewNoteState>(
        listener: (_, state) {
          switch (state.runtimeType) {
            case NotesRedirect:
              Navigator.of(context).pop();
              break;
            case Error:
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Something went wrong. Check your internet connection'
                  ),
                )
              );
          }
        },
        buildWhen: (_, state) => state is Loading || state is InputForm,
        // ignore: missing_return
        builder: (context, state) {
          switch (state.runtimeType) {
            case Loading:
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case InputForm:
              return _buildInputForm(context);
          }
        },
      ),
    );
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
                BlocProvider.of<NewNoteBloc>(context).add(
                  TitleChanged(value)
                );
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
                BlocProvider.of<NewNoteBloc>(context).add(
                  TextChanged(value)
                );
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
            BlocProvider.of<NewNoteBloc>(context).add(
              SaveNote()
            );
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
