import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:auth_app/data/firebase/firebase.dart';
import 'package:auth_app/data/usecases/usecases.dart';
import 'package:auth_app/domain/helpers/helpers.dart';
import 'package:faker/faker.dart';

class FirebaseAuthClientSpy extends Mock implements FirebaseAuthClient {}

void main() {
  late FirebaseAuthClientSpy firebaseAuthClientSpy;
  late RemoteSignIn sut;
  late String email;
  late String password;

  When mockFirebaseRequest() => when(
        () => firebaseAuthClientSpy.signInWithEmailAndPassword(
            email: any(named: "email"), password: any(named: "password")),
      );

  void mockFirebaseRequestError(FirebaseSignInError error) =>
      mockFirebaseRequest().thenThrow(error);

  setUp(() {
    firebaseAuthClientSpy = FirebaseAuthClientSpy();
    sut = RemoteSignIn(firebaseAuthClient: firebaseAuthClientSpy);
    email = faker.internet.email();
    password = faker.internet.password();
  });

  test('Should call FirebaseAuthClient with correct values', () async {
    when(() => firebaseAuthClientSpy.signInWithEmailAndPassword(
        email: any(named: "email"),
        password: any(named: "password"))).thenAnswer((_) async => _);

    await sut.signin(email: email, password: password);

    verify(
      () => firebaseAuthClientSpy.signInWithEmailAndPassword(
          email: email, password: password),
    );
  });

  test(
      'Should throw UserDisabledError if FirebaseAuthClient throws user-disabled',
      () async {
    mockFirebaseRequestError(FirebaseSignInError.userDisabled);

    final future = sut.signin(email: email, password: password);

    expect(future, throwsA(DomainError.userDisabled));
  });

  test(
      'Should throw UserNotFoundError if FirebaseAuthClient throws user-not-found',
      () async {
    mockFirebaseRequestError(FirebaseSignInError.userNotFound);

    final future = sut.signin(email: email, password: password);

    expect(future, throwsA(DomainError.userNotFound));
  });

  test(
      'Should throw InvalidCredentialsError if FirebaseAuthClient throws invalid-email',
      () async {
    mockFirebaseRequestError(FirebaseSignInError.invalidEmail);

    final future = sut.signin(email: email, password: password);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test(
      'Should throw InvalidCredentialsError if FirebaseAuthClient throws wrong-password',
      () async {
    mockFirebaseRequestError(FirebaseSignInError.wrongPassword);

    final future = sut.signin(email: email, password: password);

    expect(future, throwsA(DomainError.invalidCredentials));
  });
}
