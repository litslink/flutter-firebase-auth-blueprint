import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'data/repository/auth_repository.dart';
import 'data/util/image_manager.dart';

final List<SingleChildWidget> providers = [
  Provider<FirebaseAuth>(create: (_) => FirebaseAuth.instance),
  Provider<FirebaseStorage>(create: (_) => FirebaseStorage.instance),
  Provider<GoogleSignIn>(create: (_) => GoogleSignIn()),
  ProxyProvider<FirebaseStorage, ImageManager>(
    update: (_, storage, __) => ImageManager(storage),
  ),
  ProxyProvider2<FirebaseAuth, GoogleSignIn, AuthRepository>(
    update: (_, auth, googleSignIn, __) => AuthRepository(auth, googleSignIn),
  )
];
