import 'package:auth_app/domain/helpers/helpers.dart';
import 'package:auth_app/presentation/controllers/sign_in/sign_in.dart';
import 'package:auth_app/presentation/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:value_listenable_test/value_listenable_test.dart';

import '../../mocks/mocks.dart';


void main() {
  late SignInSpy signInSpy;
  late SignInController sut;
  late String email;
  late String password;

  setUp(() {
    signInSpy = SignInSpy();
    sut = SignInController(signIn: signInSpy);
    email = faker.internet.email();
    password = faker.internet.password();

    signInSpy.mockSignInResponse();
  });

  test('Should call SignIn with correct values', () async {
    await sut(email: email, password: password);

    verify(() => signInSpy(email: email, password: password));
  });

  test('Should emit correct states on success', () async {
    expect(
        sut,
        emitValues([
          isA<SignInLoading>(),
          isA<SignInSuccess>(),
          isA<SignInInitial>(),
        ]));

    await sut(email: email, password: password);
  });

  test(
      'Should emit UIInvalidCredentialsError if SignIn throws invalidCredentials',
      () async {
    signInSpy.mockSignInResponseError(DomainError.invalidCredentials);

    expect(
        sut,
        emitValues([
          isA<SignInLoading>(),
          isA<SignInFailed>().having((p0) => p0.uiError,
              "Should contain unexpected error", UIError.invalidCredentials),
          isA<SignInInitial>(),
        ]));

    sut(email: email, password: password);
  });

  test('Should emit UIUnexpectedError if SignIn throws unexpected', () async {
    signInSpy.mockSignInResponseError(DomainError.unexpected);

    expect(
        sut,
        emitValues([
          isA<SignInLoading>(),
          isA<SignInFailed>().having((p0) => p0.uiError,
              "Should contain unexpected error", UIError.unexpected),
          isA<SignInInitial>(),
        ]));

    sut(email: email, password: password);
  });
}
