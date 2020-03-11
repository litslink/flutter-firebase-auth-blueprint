import 'dart:async';

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

  Future<String> requestPhoneVerification(
      String phoneNumber,
      [Duration timeout = const Duration(seconds: 60)]) async {
    final verificationIdCompleter = Completer<String>();
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: null,
        verificationFailed: verificationIdCompleter.completeError,
        codeSent: (verificationId, [_]) {
          verificationIdCompleter.complete(verificationId);
        },
        codeAutoRetrievalTimeout: null
    );
    return verificationIdCompleter.future;
  }
  
  Future<void> signInWithPhone(String verificationId, String smsCode) async {
    final credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsCode
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
      networkModel.photoUrl,
      networkModel.phoneNumber
    ) : null;
  }
}
