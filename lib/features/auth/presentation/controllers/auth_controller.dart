import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

final authControllerProvider =
    Provider<AuthController>((ref) => AuthController());

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      // Listen for the authentication event
      final completer = Completer<GoogleSignInAccount?>();
      late final StreamSubscription sub;
      sub = googleSignIn.authenticationEvents.listen((event) {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          completer.complete(event.user);
          sub.cancel();
        } else if (event is GoogleSignInAuthenticationEventSignOut) {
          completer.complete(null);
          sub.cancel();
        }
      });

      await googleSignIn.authenticate();

      final user = await completer.future;
      if (user == null) return null;

      final auth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      return result.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signInWithPhone(
    String phoneNumber,
    Function(String, int?) codeSent,
    Function(FirebaseAuthException) onError,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: onError,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (_) {},
    );
  }
}
