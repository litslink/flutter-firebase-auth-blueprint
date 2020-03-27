import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class NewNoteDelegate {

  void closeScreen();

  void showError();
}

class NewNoteDelegateImpl extends NewNoteDelegate {
  final BuildContext context;

  NewNoteDelegateImpl(this.context);

  @override
  void closeScreen() => Navigator.of(context).pop();

  @override
  void showError() => Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text('Something went wrong. Check your internet connection'),
    )
  );
}
