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
}
