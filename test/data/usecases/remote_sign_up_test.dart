import 'package:auth_app/data/usecases/usecases.dart';
import 'package:auth_app/domain/helpers/helpers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:auth_app/data/firebase/firebase.dart';
import 'package:faker/faker.dart';

class FirebaseAuthClientSpy extends Mock implements FirebaseAuthClient {}

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

    await sut(email: email, password: password);

    verify(() => firebaseAuthClientSpy.createUserWithEmailAndPassword(
        email: email, password: password));
  });

  test(
      'Should throw emailInUseError if FirebaseAuthClient throws emailAlreadyInUse',
      () async {
    mockFirebaseAuthRequestError(FirebaseSignUpError.emailAlreadyInUse);

    final future = sut(email: email, password: password);

    expect(future, throwsA(DomainError.emailInUse));
  });

  test(
      'Should throw InvalidEmailError if FirebaseAuthClient throws invalidEmail',
      () async {
    mockFirebaseAuthRequestError(FirebaseSignUpError.invalidEmail);

    final future = sut(email: email, password: password);

    expect(future, throwsA(DomainError.invalidEmail));
  });

  test(
      'Should throw UserDisabledError if FirebaseAuthClient throws operationNotAllowed',
      () async {
    mockFirebaseAuthRequestError(FirebaseSignUpError.operationNotAllowed);

    final future = sut(email: email, password: password);

    expect(future, throwsA(DomainError.userDisabled));
  });

  test(
      'Should throw WeakPasswordError if FirebaseAuthClient throws weakPassword',
      () async {
    mockFirebaseAuthRequestError(FirebaseSignUpError.weakPassword);

    final future = sut(email: email, password: password);

    expect(future, throwsA(DomainError.weakPassword));
  });
}
