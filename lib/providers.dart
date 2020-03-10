import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'repository/auth_repository.dart';

final List<SingleChildWidget> providers = [
  Provider<FirebaseAuth>(create: (_) => FirebaseAuth.instance),
  ProxyProvider<FirebaseAuth, AuthRepository>(
    update: (_, auth, __) => AuthRepository(auth),
  )
];
