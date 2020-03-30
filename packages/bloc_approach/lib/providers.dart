import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/auth_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/notes_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/data/repository/settings_repository.dart';
import 'package:flutter_firebase_auth_blueprint_common/util/image_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providers = [
  Provider<FirebaseAuth>(create: (_) => FirebaseAuth.instance),
  Provider<FirebaseStorage>(create: (_) => FirebaseStorage.instance),
  Provider<FirebaseDatabase>(create: (_) => FirebaseDatabase.instance),
  Provider<GoogleSignIn>(create: (_) => GoogleSignIn()),
  ProxyProvider<FirebaseDatabase, SettingsRepository>(
    update: (_, database, __) => SettingsRepository(database),
  ),
  ProxyProvider<FirebaseDatabase, NotesRepository>(
    update: (_, database, __) => NotesRepository(database),
  ),
  ProxyProvider<FirebaseStorage, ImageManager>(
    update: (_, storage, __) => ImageManager(storage),
  ),
  ProxyProvider2<FirebaseAuth, GoogleSignIn, AuthRepository>(
    update: (_, auth, googleSignIn, __) => AuthRepository(auth, googleSignIn),
  )
];
