import 'package:firebase_auth/firebase_auth.dart';
import '../model/user.dart';

class AuthRepository {

  final FirebaseAuth auth;

  AuthRepository(this.auth);

  Future<void> signUp(String email, String password) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<User> getUser() async {
    final networkModel = await auth.currentUser();
    return networkModel != null ? User(
      networkModel.email,
      networkModel.displayName,
      networkModel.photoUrl
    ) : null;
  }
}
