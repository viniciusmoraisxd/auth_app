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
        case FirebaseSignUpError.invalidEmail:
          throw DomainError.invalidEmail;
        case FirebaseSignUpError.operationNotAllowed:
          throw DomainError.userDisabled;
        case FirebaseSignUpError.weakPassword:
          throw DomainError.weakPassword;
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

  test(
      'Should throw InvalidEmailError if FirebaseAuthClient throws invalidEmail',
      () async {
    mockFirebaseAuthRequestError(FirebaseSignUpError.invalidEmail);

    final future = sut.signup(email: email, password: password);

    expect(future, throwsA(DomainError.invalidEmail));
  });

  test(
      'Should throw UserDisabledError if FirebaseAuthClient throws operationNotAllowed',
      () async {
    mockFirebaseAuthRequestError(FirebaseSignUpError.operationNotAllowed);

    final future = sut.signup(email: email, password: password);

    expect(future, throwsA(DomainError.userDisabled));
  });

  test(
      'Should throw WeakPasswordError if FirebaseAuthClient throws weakPassword',
      () async {
    mockFirebaseAuthRequestError(FirebaseSignUpError.weakPassword);

    final future = sut.signup(email: email, password: password);

    expect(future, throwsA(DomainError.weakPassword));
  });
}

