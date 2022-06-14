import 'package:firebase_auth/firebase_auth.dart';
import '../../data/firebase/firebase.dart';

class FirebaseAuthAdapter implements FirebaseAuthClient {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthAdapter({required this.firebaseAuth});

  @override
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-disabled":
          throw FirebaseSignInError.userDisabled;
        case "user-not-found":
          throw FirebaseSignInError.userNotFound;
        case "invalid-email":
          throw FirebaseSignInError.invalidEmail;
        case "wrong-password":
          throw FirebaseSignInError.wrongPassword;
      }
    }
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      {required String email, required String password}) async {}
}
