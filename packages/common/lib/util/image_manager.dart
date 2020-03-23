import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageManager {
  final FirebaseStorage storage;

  ImageManager(this.storage);

  Future<String> loadUserPhoto(File file, String userId) async {
    final storageReference = FirebaseStorage.instance
        .ref()
        .child('user/photo/$userId');
    final uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    return await storageReference.getDownloadURL() as String;
  }
}
