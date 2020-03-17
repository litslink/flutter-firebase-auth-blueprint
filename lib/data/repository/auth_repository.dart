import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_auth_blueprint/data/model/auth_state.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../model/user.dart';

class AuthRepository {

  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  AuthRepository(this.auth, this.googleSignIn);

  final _authStateController = StreamController<AuthState>.broadcast();

  Future<void> signUp(String name, String email, String password) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    await updateUserName(name);
    await _triggerAuthChanges();
  }

  Future<void> signIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    await _triggerAuthChanges();
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken
    );
    await auth.signInWithCredential(credential);
    await _triggerAuthChanges();
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
    await _triggerAuthChanges();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> updateUserName(String name) async {
    final currentUser = await auth.currentUser();
    if (currentUser.displayName != name) {
      final info = UserUpdateInfo()
        ..displayName = name;
      await currentUser.updateProfile(info);
      await _triggerAuthChanges();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updatePhotoUrl(String photoUrl) async {
    final currentUser = await auth.currentUser();
    if (currentUser.photoUrl != photoUrl) {
      final info = UserUpdateInfo()
        ..photoUrl = photoUrl;
      await currentUser.updateProfile(info);
      await _triggerAuthChanges();
      return true;
    } else {
      return false;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
    await _triggerAuthChanges();
  }

  Stream<AuthState> authState() => _authStateController.stream;

  Future<User> getUser() async {
    final networkModel = await auth.currentUser();
    return networkModel != null ? User(
        networkModel.email,
        networkModel.displayName,
        networkModel.photoUrl,
        networkModel.phoneNumber,
        networkModel.uid
    ) : null;
  }

  Future<void> _triggerAuthChanges() async {
    final user = await getUser();
    AuthState state;
    if (user != null) {
      state = Authenticated(user);
    } else {
      state  = Unauthenticated();
    }
    _authStateController.add(state);
  }
}
