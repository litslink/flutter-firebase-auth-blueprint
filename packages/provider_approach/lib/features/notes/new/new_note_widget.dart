import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/new/new_note_delegate.dart';
import 'package:flutter_firebase_auth_blueprint/features/notes/new/new_note_model.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/notes_repository.dart';
import 'package:provider/provider.dart';

class NewNoteWidget extends StatelessWidget {
  static final String route = '/new_note';

  @override
  Widget build(BuildContext context) {
    final notesRepository = Provider.of<NotesRepository>(context);
    final authRepository = Provider.of<AuthRepository>(context);
    return ChangeNotifierProvider(
      create: (_) => NewNoteModel(
        notesRepository,
        authRepository,
        NewNoteDelegateImpl(context)
      ),
      child: Consumer<NewNoteModel>(
        // ignore: missing_return
        builder: (_, model, __) {
          switch (model.state) {
            case ViewState.inputForm: return _buildInputForm(context, model);
            case ViewState.loading: return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildInputForm(BuildContext context, NewNoteModel model) {
    return Scaffold(
      appBar: _buildAppBar(model),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autofocus: true,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: model.titleChanged,
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
              onChanged: model.textChanged,
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

  AppBar _buildAppBar(NewNoteModel model) {
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
          onPressed: model.saveNote,
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