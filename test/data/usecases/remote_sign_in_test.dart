import 'package:auth_app/domain/helpers/domain_errors.dart';
import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class RemoteSignIn {
  final FirebaseAuthClient firebaseAuthClient;

  RemoteSignIn({required this.firebaseAuthClient});

  Future signin({required String email, required String password}) async {
    try {
      await firebaseAuthClient.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseError catch (e) {
      switch (e) {
        case FirebaseError.userDisabled:
          throw DomainError.userDisabled;
        case FirebaseError.userNotFound:
          throw DomainError.userNotFound;
      }
    }
  }
}

abstract class FirebaseAuthClient {
  Future<dynamic>? signInWithEmailAndPassword(
      {required String email, required String password});
}

class FirebaseAuthClientSpy extends Mock implements FirebaseAuthClient {}

enum FirebaseError { userDisabled, userNotFound }

void main() {
  late FirebaseAuthClientSpy firebaseAuthClientSpy;
  late RemoteSignIn sut;
  late String email;
  late String password;

  setUp(() {
    firebaseAuthClientSpy = FirebaseAuthClientSpy();
    sut = RemoteSignIn(firebaseAuthClient: firebaseAuthClientSpy);
    email = faker.internet.email();
    password = faker.internet.password();
  });

  test('Should call FirebaseAuthClient with correct values', () async {
    await sut.signin(email: email, password: password);

    verify(
      () => firebaseAuthClientSpy.signInWithEmailAndPassword(
          email: email, password: password),
    );
  });

  test(
      'Should throw UserDisabledError if FirebaseAuthClient throws user-disabled',
      () async {
    when(
      () => firebaseAuthClientSpy.signInWithEmailAndPassword(
          email: any(named: "email"), password: any(named: "password")),
    ).thenThrow(FirebaseError.userDisabled);

    final future = sut.signin(email: email, password: password);

    expect(future, throwsA(DomainError.userDisabled));
  });

  test(
      'Should throw UserNotFoundError if FirebaseAuthClient throws user-not-found',
      () async {
    when(
      () => firebaseAuthClientSpy.signInWithEmailAndPassword(
          email: any(named: "email"), password: any(named: "password")),
    ).thenThrow(FirebaseError.userNotFound);

    final future = sut.signin(email: email, password: password);

    expect(future, throwsA(DomainError.userNotFound));
  });
}
