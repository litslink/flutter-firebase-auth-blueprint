abstract class AuthState {}

class Loading extends AuthState {}

class AuthRequired extends AuthState {}

class AuthSuccessful extends AuthState {
  final String name;

  AuthSuccessful(this.name);
}
