import 'package:auth_app/presentation/helpers/i18n/i18n.dart';

enum UIError {
  requiredField,
  invalidField,
  unexpected,
  invalidCredentials,
  emailInUse,
  userDisabled,
  userNotFound,
  weakPassword
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.requiredField:
        return R.strings.msgRequiredField;

      case UIError.invalidField:
        return R.strings.msgInvalidField;

      case UIError.invalidCredentials:
        return R.strings.msgInvalidCredentials;

      case UIError.emailInUse:
        return R.strings.msgEmailInUse;

      case UIError.userDisabled:
        return R.strings.msgUserDisabled;

      case UIError.userNotFound:
        return R.strings.msgUserNotFound;

      case UIError.weakPassword:
        return R.strings.msgWeakPassword;

      default:
        return R.strings.msgUnexpectedError;
    }
  }
}
