import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/consts/errors.dart';
// import 'package:sepapka/services/user_service.dart';
// import 'package:sepapka/utils/api_status.dart';
// import 'package:sepapka/utils/consts/errors_messages.dart';
// import 'package:sepapka/controllers/app_state_controller.dart';

// final authServiceProvider = Provider.autoDispose<AuthService>((ref) {
//   return AuthService(ref);
// });

final authStateProvider = StreamProvider.autoDispose<User?>((ref) {
  return ref.watch(AuthService.provider).authStateChange;
});

class AuthService {
  static final provider =
      Provider.autoDispose<AuthService>((ref) => AuthService(ref));
  //Properties
  final Ref _ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  // To test web app on correct port, run:
  // flutter run -d chrome --web-hostname localhost --web-port 8080

  //  This getter will be returning a Stream of User object.
  //  It will be used to check if the user is logged in or not.
  Stream<User?> get authStateChange => _auth.authStateChanges();

  //Constructor - default
  AuthService(this._ref) {
    log('^^^ authService initialized ^^^');
    // watchAuthUser();
  }

  // watchAuthUser() {
  //   authStateChange.listen((User? user) async {
  //     if (user != null) {
  //       log('/// AuthService: User signed in ///');
  //       _ref.read(userService.notifier).getUserFromDb(user.uid);
  //     }
  //     if (user == null) {
  //       log('/// AuthService: User signed out ///');
  //       _ref.read(appStateNotifierProvider.notifier).userSignedOut();
  //       // _ref.read(routeController).navigate(MyScreen.signIn);
  //     }
  //   });
  // }

  //Getters
  // FirebaseAuth get auth => _auth;

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
      return MyError.errorSignInGoogle;
    }
  }

  Future<String?> signOut() async {
    try {
      await _auth.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      return getMessageFromErrorCode(e.code);
    }
  }

  String getMessageFromErrorCode(String code) {
    switch (code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Ten adres e-mail jest już zajęty. Spróbuj się zalogować";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Nieprawidłowe hasło";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "Nie znaleziono konta zarejestrowanego na podany adres e-mail";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "Użytkownik jest zablokowany";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Tymczasowo zablokowano dostęp ze względu na zbyt częste próby logownia. Spróbuj później";
      case "too-many-requests":
        return "Tymczasowo zablokowano dostęp ze względu na zbyt częste próby logownia. Spróbuj później";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Nieprawidłowy adres e-mail";
      case "network-request-failed":
        return "Brak połączenia z internetem, spróbuj ponownie";
      default:
        return "Błąd logowania, spróbuj ponownie";
    }
  }
}
