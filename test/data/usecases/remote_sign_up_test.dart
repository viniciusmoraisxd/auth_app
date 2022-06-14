import 'package:auth_app/domain/helpers/helpers.dart';
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
  Future<void> signup({required String email, required String password}) async {
    try {
      await firebaseAuthClient.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseSignUpError catch (e) {
      switch (e) {
        case FirebaseSignUpError.emailAlreadyInUse:
          throw DomainError.emailInUse;
      }
    }
  }
}

void main() {
  late FirebaseAuthClientSpy firebaseAuthClientSpy;
  late RemoteSignUp sut;
  late String email;
  late String password;

  When mockFirebaseAuthRequest() =>
      when(() => firebaseAuthClientSpy.createUserWithEmailAndPassword(
          email: any(named: "email"), password: any(named: "password")));

  void mockFirebaseAuthRequestError(FirebaseSignUpError error) =>
      mockFirebaseAuthRequest().thenThrow(error);

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

  test(
      'Should throw emailInUseError if FirebaseAuthClient throws emailAlreadyInUse',
      () async {
    mockFirebaseAuthRequestError(FirebaseSignUpError.emailAlreadyInUse);

    final future = sut.signup(email: email, password: password);

    expect(future, throwsA(DomainError.emailInUse));
  });
}

// email-already-in-use:
// Thrown if there already exists an account with the given email address.
// invalid-email:
// Thrown if the email address is not valid.
// operation-not-allowed:
// Thrown if email/password accounts are not enabled. Enable email/password accounts in the Firebase Console, under the Auth tab.
// weak-password:
// Thrown if the password is not strong enough.
