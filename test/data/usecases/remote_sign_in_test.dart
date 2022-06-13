import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class RemoteSignIn {
  final FirebaseAuthClient firebaseAuthClient;

  RemoteSignIn({required this.firebaseAuthClient});

  Future signin({required String email, required String password}) async {
    await firebaseAuthClient.signInWithEmailAndPassword(
        email: email, password: password);
  }
}

abstract class FirebaseAuthClient {
  Future<dynamic>? signInWithEmailAndPassword(
      {required String email, required String password});
}

class FirebaseAuthClientSpy extends Mock implements FirebaseAuthClient {}

void main() {
  test('Should call FirebaseAuthClient with correct values', () async {
    final firebaseAuthClientSpy = FirebaseAuthClientSpy();
    final sut = RemoteSignIn(firebaseAuthClient: firebaseAuthClientSpy);

    final email = faker.internet.email();
    final password = faker.internet.password();

    await sut.signin(email: email, password: password);

    verify(
      () => firebaseAuthClientSpy.signInWithEmailAndPassword(
          email: email, password: password),
    );
  });
}
