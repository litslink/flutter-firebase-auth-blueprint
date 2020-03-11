import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user.dart';

class AuthRepository {

  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  AuthRepository(this.auth, this.googleSignIn);

  Future<void> signUp(String email, String password) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
    );
    await auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
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
