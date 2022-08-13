import 'package:auth_app/domain/helpers/helpers.dart';
import 'package:auth_app/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class SignUpSpy extends Mock implements SignUp {
  When mockSignUpCall() => when(
      () => call(email: any(named: "email"), password: any(named: "password")));

  void mockSignUpResponse() => mockSignUpCall().thenAnswer((_) async => _);

  void mockSignUpResponseError(DomainError error) =>
      mockSignUpCall().thenThrow(error);
}
