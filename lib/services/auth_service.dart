import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo/controllers/user_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/consts/errors.dart';

class AuthService {
  static final provider = Provider<AuthService>((ref) => AuthService(ref));
  //Properties
  final Ref _ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChange => _auth.authStateChanges();

  AuthService(this._ref) {
    log('^^^ authService initialized ^^^');
    // watchAuthUser();
  }

  // watchAuthUser() {
  //   _auth.authStateChanges().listen((User? user) async {
  //     if (user != null) {
  //       debugPrint('/// AuthService: User signed in ///');
  //       _ref.read(UserController.provider).getUserFromDb(user.uid);
  //     }
  //   });
  // }

  Future<String?> signUpEmail(String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(
            const Duration(seconds: 5),
          );
      return null;
    } on FirebaseAuthException catch (e) {
      return getMessageFromErrorCode(e.code);
    } on TimeoutException {
      return MyError.signInTimeout;
    }
  }

  Future<String?> signInEmail(String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(
            const Duration(seconds: 5),
          );
      return null;
    } on FirebaseAuthException catch (e) {
      return getMessageFromErrorCode(e.code);
    } on TimeoutException {
      return MyError.signInTimeout;
    }
  }

  Future<String?> signInGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      return null;
    } catch (e) {
      return MyError.signInGoogle;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String getMessageFromErrorCode(String code) {
    switch (code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "This e-mail was already used. Try to sign in";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong password";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "We didn't find an account associated with this e-mail address";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "Account is disabled";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Access is temporarly disabled. Try again later.";
      case "too-many-requests":
        return "Access is temporarly disabled. Try again later.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Invalid e-mail";
      case "network-request-failed":
        return "Turn on internet connection and try again";
      default:
        return "Sign in error, try again later";
    }
  }
}
