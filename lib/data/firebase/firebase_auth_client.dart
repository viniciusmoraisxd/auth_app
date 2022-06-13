abstract class FirebaseAuthClient {
  Future<dynamic>? signInWithEmailAndPassword(
      {required String email, required String password});
}