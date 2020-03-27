import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/model/note.dart';

class NotesRepository {
  final FirebaseDatabase _database;

  NotesRepository(this._database);

  Future<void> add(String userId, Note note) async {
    final ref = await _database.reference()
      .child(userId)
      .child('notes')
      .push();

    final data = {
      'title': note.title,
      'text': note.text
    };
    await ref.set(data);
  }

  Future<void> delete(String userId, Note note) async {
    final ref = await _database.reference()
      .child(userId)
      .child('notes')
      .child(note.id);

    await ref.remove();
  }

  Stream<List<Note>> get(String userId) async* {
    final ref = _database.reference()
      .child(userId)
      .child('notes')
      .reference();

    final isExist = (await ref.once()).value != null;
    if (!isExist) {
      yield [];
    }
    yield* ref.onValue.map((e) => _mapToList(e.snapshot));
  }

  List<Note> _mapToList(DataSnapshot snapshot) => (snapshot.value as Map)
    .entries
    .map<Note>(
      (entry) => Note(
        entry.key as String,
        entry.value['title'] as String,
        entry.value['text'] as String
      )
    )
    .toList();
}
