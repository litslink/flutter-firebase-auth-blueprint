import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'repository/auth_repository.dart';

final List<SingleChildWidget> providers = [
  Provider<FirebaseAuth>(create: (_) => FirebaseAuth.instance),
  Provider<GoogleSignIn>(create: (_) => GoogleSignIn()),
  ProxyProvider2<FirebaseAuth, GoogleSignIn, AuthRepository>(
    update: (_, auth, googleSignIn, __) => AuthRepository(auth, googleSignIn),
  )
];
