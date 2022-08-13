import 'package:auth_app/domain/helpers/helpers.dart';
import 'package:auth_app/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

class SignInSpy extends Mock implements SignIn {
  When mockSignInCall() => when(
      () => call(email: any(named: "email"), password: any(named: "password")));

  void mockSignInResponse() => mockSignInCall().thenAnswer((_) async => _);

  void mockSignInResponseError(DomainError error) =>
      mockSignInCall().thenThrow(error);
}
