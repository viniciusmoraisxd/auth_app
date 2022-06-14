import 'package:flutter/material.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../domain/helpers/helpers.dart';
import '../../helpers/helpers.dart';
part 'login_state.dart';

class LoginController extends ValueNotifier<LoginState> {
  final SignIn signIn;

  LoginController({required this.signIn}) : super(LoginInitial());

  Future login({required String email, required String password}) async {
    try {
      value = AuthenticationLoading();
      await signIn.signin(email: email, password: password);

      value = AuthenticationSuccess();
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.userDisabled:
          value = AuthenticationFailed(error: UIError.userDisabled.description);
          break;
        case DomainError.userNotFound:
          value = AuthenticationFailed(error: UIError.userNotFound.description);
          break;
        case DomainError.invalidCredentials:
          value = AuthenticationFailed(
              error: UIError.invalidCredentials.description);
          break;
        default:
          value = AuthenticationFailed(error: UIError.unexpected.description);
          break;
      }

      await Future.delayed(const Duration(seconds: 1));
      value = LoginInitial();
    }
  }
}
