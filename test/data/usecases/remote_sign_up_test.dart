import 'package:auth_app/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:auth_app/data/firebase/firebase.dart';
import 'package:faker/faker.dart';

class FirebaseAuthClientSpy extends Mock implements FirebaseAuthClient {}

class RemoteSignUp implements SignUp {
  final FirebaseAuthClient firebaseAuthClient;

  RemoteSignUp({required this.firebaseAuthClient});

  @override
  Future signup({required String email, required String password}) async {
    await firebaseAuthClient.createUserWithEmailAndPassword(
        email: email, password: password);
  }
}

void main() {
  late FirebaseAuthClientSpy firebaseAuthClientSpy;
  late RemoteSignUp sut;
  late String email;
  late String password;

  setUp(() {
    firebaseAuthClientSpy = FirebaseAuthClientSpy();
    sut = RemoteSignUp(firebaseAuthClient: firebaseAuthClientSpy);
    email = faker.internet.email();
    password = faker.internet.password();
  });

  test('Should call FirebaseAuthClient with correct values', () async {
    when(() => firebaseAuthClientSpy.createUserWithEmailAndPassword(
        email: any(named: "email"),
        password: any(named: "password"))).thenAnswer((_) async => _);

    await sut.signup(email: email, password: password);

    verify(() => firebaseAuthClientSpy.createUserWithEmailAndPassword(
        email: email, password: password));
  });
}
