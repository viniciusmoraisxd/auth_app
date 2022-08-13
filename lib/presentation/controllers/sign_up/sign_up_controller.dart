import 'package:flutter/material.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/sign_up.dart';
import '../../helpers/helpers.dart';

part 'sign_up_state.dart';

class SignUpController extends ValueNotifier<SignUpState> {
  final SignUp signUp;

  SignUpController({
    required this.signUp,
  }) : super(SignUpInitial());

  Future<void> call({
    required String email,
    required String password,
  }) async {
    value = SignUpLoading();

    try {
      await signUp(email: email, password: password);
      value = SignUpSuccess();
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.emailInUse:
          value = const SignUpFailed(uiError: UIError.emailInUse);
          break;
        case DomainError.invalidEmail:
          value = const SignUpFailed(uiError: UIError.invalidField);
          break;
        case DomainError.userDisabled:
          value = const SignUpFailed(uiError: UIError.userDisabled);
          break;
        case DomainError.weakPassword:
          value = const SignUpFailed(uiError: UIError.weakPassword);
          break;
        default:
          value = const SignUpFailed(uiError: UIError.unexpected);
          break;
      }
    }

    await Future.delayed(const Duration(seconds: 1));
    value = SignUpInitial();
  }
}
