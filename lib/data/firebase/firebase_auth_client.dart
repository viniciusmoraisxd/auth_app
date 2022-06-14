
abstract class FirebaseAuthClient {
  Future<void> signInWithEmailAndPassword(
      {required String email, required String password});
}