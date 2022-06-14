import 'package:auth_app/data/firebase/firebase.dart';
import 'package:auth_app/infra/firebase/firebase.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks/mocks.dart';

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
    firebaseAuthSpy.mockSignUp();
  });

  group("Sign in with email and password", () {
    test('Should call signInWithEmailAndPassword with correct values',
        () async {
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

      expect(future, throwsA(FirebaseSignInError.userDisabled));
    });

    test(
        'Should throw FirebaseUserNotFoundError if signInWithEmailAndPassword throws user-not-found',
        () async {
      firebaseAuthSpy.mockSignInError('user-not-found');

      final future =
          sut.signInWithEmailAndPassword(email: email, password: password);

      expect(future, throwsA(FirebaseSignInError.userNotFound));
    });

    test(
        'Should throw FirebaseInvalidCredentialsError if signInWithEmailAndPassword throws invalid-email',
        () async {
      firebaseAuthSpy.mockSignInError('invalid-email');

      final future =
          sut.signInWithEmailAndPassword(email: email, password: password);

      expect(future, throwsA(FirebaseSignInError.invalidEmail));
    });

    test(
        'Should throw FirebaseInvalidCredentialsError if signInWithEmailAndPassword throws wrong-password',
        () async {
      firebaseAuthSpy.mockSignInError('wrong-password');

      final future =
          sut.signInWithEmailAndPassword(email: email, password: password);

      expect(future, throwsA(FirebaseSignInError.wrongPassword));
    });
  });

  group("Create user with email and password", () {
    test('Should call createUserWithEmailAndPassword with correct values',
        () async {
      await sut.createUserWithEmailAndPassword(
          email: email, password: password);

      verify(() => firebaseAuthSpy.createUserWithEmailAndPassword(
          email: email, password: password));
    });

    test(
        'Should throw FirebaseUserDisabledError if signInWithEmailAndPassword throws operation-not-allowed',
        () async {
      firebaseAuthSpy.mockSignUpError('operation-not-allowed');

      final future =
          sut.createUserWithEmailAndPassword(email: email, password: password);

      expect(future, throwsA(FirebaseSignUpError.operationNotAllowed));
    });

    test(
        'Should throw FirebaseUserNotFoundError if signInWithEmailAndPassword throws email-already-in-use',
        () async {
      firebaseAuthSpy.mockSignUpError('email-already-in-use');

      final future =
          sut.createUserWithEmailAndPassword(email: email, password: password);

      expect(future, throwsA(FirebaseSignUpError.emailAlreadyInUse));
    });

    test(
        'Should throw FirebaseInvalidCredentialsError if signInWithEmailAndPassword throws invalid-email',
        () async {
      firebaseAuthSpy.mockSignUpError('invalid-email');

      final future =
          sut.createUserWithEmailAndPassword(email: email, password: password);

      expect(future, throwsA(FirebaseSignUpError.invalidEmail));
    });

    test(
        'Should throw FirebaseInvalidCredentialsError if signInWithEmailAndPassword throws weak-password',
        () async {
      firebaseAuthSpy.mockSignUpError('weak-password');

      final future =
          sut.createUserWithEmailAndPassword(email: email, password: password);

      expect(future, throwsA(FirebaseSignUpError.weakPassword));
    });
  });
}
