import 'package:flutter_firebase_auth_blueprint/data/model/user.dart';

abstract class AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}
