import 'package:flutter/material.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../domain/helpers/helpers.dart';
import '../../helpers/helpers.dart';
part 'sign_in_state.dart';

class SignInController extends ValueNotifier<SignInState> {
  final SignIn signIn;

  SignInController({required this.signIn}) : super(SignInInitial());

  Future<void>? call({required String email, required String password}) async {
    value = SignInLoading();

    try {
      await signIn.call(email: email, password: password);

      value = SignInSuccess();
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.userDisabled:
          value = SignInFailed(uiError: UIError.userDisabled);
          break;
        case DomainError.userNotFound:
          value = SignInFailed(uiError: UIError.userNotFound);
          break;
        case DomainError.invalidCredentials:
          value = SignInFailed(uiError: UIError.invalidCredentials);
          break;
        default:
          value = SignInFailed(uiError: UIError.unexpected);
          break;
      }
    }

    await Future.delayed(const Duration(seconds: 1));
    value = SignInInitial();
  }
}
