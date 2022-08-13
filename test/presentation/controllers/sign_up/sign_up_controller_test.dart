import 'package:auth_app/domain/helpers/helpers.dart';
import 'package:auth_app/presentation/controllers/controllers.dart';
import 'package:auth_app/presentation/helpers/helpers.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';
import 'package:value_listenable_test/value_listenable_test.dart';

import '../../mocks/mocks.dart';

void main() {
  late SignUpSpy signUpSpy;
  late SignUpController sut;
  late String email;
  late String password;

  setUp(() {
    signUpSpy = SignUpSpy();
    sut = SignUpController(signUp: signUpSpy);
    email = faker.internet.email();
    password = faker.internet.password();

    signUpSpy.mockSignUpResponse();
  });

  test('Should call SignUp with correct values', () async {
    await sut(email: email, password: password);

    verify(() => signUpSpy(email: email, password: password));
  });

  test('Should emit correct states on success', () async {
    expect(
        sut,
        emitValues([
          isA<SignUpLoading>(),
          isA<SignUpSuccess>(),
          isA<SignUpInitial>(),
        ]));

    await sut(email: email, password: password);
  });

  test('Should emit emailInUseError if SignUp throws emailInUse', () async {
    signUpSpy.mockSignUpResponseError(DomainError.emailInUse);

    expect(
        sut,
        emitValues([
          isA<SignUpLoading>(),
          isA<SignUpFailed>().having((p0) => p0.uiError,
              "Should contain emailInUse error", UIError.emailInUse),
          isA<SignUpInitial>(),
        ]));

    sut(email: email, password: password);
  });

  test('Should emit invalidEmailError if SignUp throws invalidEmail', () async {
    signUpSpy.mockSignUpResponseError(DomainError.invalidEmail);

    expect(
        sut,
        emitValues([
          isA<SignUpLoading>(),
          isA<SignUpFailed>().having((p0) => p0.uiError,
              "Should contain invalidEmail error", UIError.invalidField),
          isA<SignUpInitial>(),
        ]));

    sut(email: email, password: password);
  });

  test('Should emit userDisabledError if SignUp throws userDisabled', () async {
    signUpSpy.mockSignUpResponseError(DomainError.userDisabled);

    expect(
        sut,
        emitValues([
          isA<SignUpLoading>(),
          isA<SignUpFailed>().having((p0) => p0.uiError,
              "Should contain userDisabled error", UIError.userDisabled),
          isA<SignUpInitial>(),
        ]));

    sut(email: email, password: password);
  });

  test('Should emit weakPasswordError if SignUp throws weakPassword', () async {
    signUpSpy.mockSignUpResponseError(DomainError.weakPassword);

    expect(
        sut,
        emitValues([
          isA<SignUpLoading>(),
          isA<SignUpFailed>().having((p0) => p0.uiError,
              "Should contain weakPassword error", UIError.weakPassword),
          isA<SignUpInitial>(),
        ]));

    sut(email: email, password: password);
  });

  test('Should emit UIIUnexpectedError if SignUp throws unexpected', () async {
    signUpSpy.mockSignUpResponseError(DomainError.unexpected);

    expect(
        sut,
        emitValues([
          isA<SignUpLoading>(),
          isA<SignUpFailed>().having((p0) => p0.uiError,
              "Should contain unexpected error", UIError.unexpected),
          isA<SignUpInitial>(),
        ]));

    sut(email: email, password: password);
  });
}
