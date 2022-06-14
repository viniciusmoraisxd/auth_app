import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseUser extends Mock implements User {}

class MockFirebaseAuthResult extends Mock implements UserCredential {}

class FirebaseAuthSpy extends Mock implements FirebaseAuth {
  When mockSignInCall() => when(() => signInWithEmailAndPassword(
      email: any(named: "email"), password: any(named: "password")));

  void mockSignIn() =>
      mockSignInCall().thenAnswer((_) async => MockFirebaseAuthResult());

  void mockSignInError(String code) =>
      mockSignInCall().thenThrow(FirebaseAuthException(code: code));
}
