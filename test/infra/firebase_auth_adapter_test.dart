import 'package:auth_app/data/firebase/firebase_auth_client.dart';
import 'package:auth_app/data/firebase/firebase_auth_error.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks/mocks.dart';

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
          throw FirebaseAuthError.userDisabled;
        case "user-not-found":
          throw FirebaseAuthError.userNotFound;
        case "invalid-email":
          throw FirebaseAuthError.invalidEmail;
        case "wrong-password":
          throw FirebaseAuthError.wrongPassword;
      }
    }
  }
}

Future<void> main() async {
  late FirebaseAuthSpy firebaseAuthSpy;
  late FirebaseAuthAdapter sut;
  late String email;
  late String password;

  setUp(() async {
    firebaseAuthSpy = FirebaseAuthSpy();
    sut = FirebaseAuthAdapter(firebaseAuth: firebaseAuthSpy);
    email = faker.internet.email();
    password = faker.internet.password();

    firebaseAuthSpy.mockSignIn();
  });

  test('Should call signInWithEmailAndPassword with correct values', () async {
    await sut.signInWithEmailAndPassword(email: email, password: password);

    verify(() => firebaseAuthSpy.signInWithEmailAndPassword(
        email: email, password: password));
  });

  test(
      'Should throw FirebaseUserDisabledError if signInWithEmailAndPassword throws user-disabled',
      () async {
    firebaseAuthSpy.mockSignInError('user-disabled');

    final future =
        sut.signInWithEmailAndPassword(email: email, password: password);

    expect(future, throwsA(FirebaseAuthError.userDisabled));
  });

  test(
      'Should throw FirebaseUserNotFoundError if signInWithEmailAndPassword throws user-not-found',
      () async {
    firebaseAuthSpy.mockSignInError('user-not-found');

    final future =
        sut.signInWithEmailAndPassword(email: email, password: password);

    expect(future, throwsA(FirebaseAuthError.userNotFound));
  });

  test(
      'Should throw FirebaseInvalidCredentialsError if signInWithEmailAndPassword throws invalid-email',
      () async {
    firebaseAuthSpy.mockSignInError('invalid-email');

    final future =
        sut.signInWithEmailAndPassword(email: email, password: password);

    expect(future, throwsA(FirebaseAuthError.invalidEmail));
  });

  test(
      'Should throw FirebaseInvalidCredentialsError if signInWithEmailAndPassword throws wrong-password',
      () async {
    firebaseAuthSpy.mockSignInError('wrong-password');

    final future =
        sut.signInWithEmailAndPassword(email: email, password: password);

    expect(future, throwsA(FirebaseAuthError.wrongPassword));
  });
}
