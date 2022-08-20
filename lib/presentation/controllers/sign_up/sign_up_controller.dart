import 'package:auth_app/domain/entities/entities.dart';
import 'package:flutter/material.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../helpers/helpers.dart';

part 'sign_up_state.dart';

class SignUpController extends ValueNotifier<SignUpState> {
  final SignUp signUp;
  final AddUser addUser;

  SignUpController({
    required this.signUp,
    required this.addUser,
  }) : super(SignUpInitial());

  Future<void> call(
      {required String email,
      required String password,
      required UserEntity userEntity}) async {
    value = SignUpLoading();

    try {
      await signUp(email: email, password: password);

      await addUser(userEntity: userEntity);

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
