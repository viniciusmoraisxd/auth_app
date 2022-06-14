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

  Future remoteSignUp({
    required String email,
    required String password,
  }) async {
    try {
      value = SignUpLoading();

      await signUp.signup(email: email, password: password);
      value = SignUpSuccess();
    } on DomainError catch (e) {
      switch (e) {
        case DomainError.emailInUse:
          value = SignUpFailed(error: UIError.emailInUse.description);
          break;
        case DomainError.invalidEmail:
          value = SignUpFailed(error: UIError.invalidField.description);
          break;
        case DomainError.userDisabled:
          value = SignUpFailed(error: UIError.userDisabled.description);
          break;
        case DomainError.weakPassword:
          value = SignUpFailed(error: UIError.weakPassword.description);
          break;
        default:
          value = SignUpFailed(error: UIError.unexpected.description);
          break;
      }
    }
  }
}
