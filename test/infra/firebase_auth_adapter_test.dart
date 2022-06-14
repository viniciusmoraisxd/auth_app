import 'package:auth_app/data/firebase/firebase_auth_client.dart';
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
    await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
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
}
