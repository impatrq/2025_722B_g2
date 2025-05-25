import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthServices {
  FirebaseAuth firebaseAuth;

  AuthServices({
    required this.firebaseAuth,
  });

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();
  Future<User?> signIn(String email, String password) async {
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      throw e;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
