import '../helpers.dart';

class InputValidators {
  static String? requiredFieldValidator({String? value}) {
    return value?.isNotEmpty == true ? null :  R.strings.msgRequiredField;
  }

  static String? emailFieldValidator({String? email}) {
    final isRequiredField = requiredFieldValidator(value: email);

    if (isRequiredField != null) return isRequiredField;

    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    final isValid = email?.isNotEmpty != true || regex.hasMatch(email!);
    return isValid ? null :  R.strings.msgInvalidEmail;
  }

  static String? compareFieldsValidator(
      {String? field, String? fieldToCompare}) {
    final isRequiredField = requiredFieldValidator(value: field);
    final isRequiredFieldCompared =
        requiredFieldValidator(value: fieldToCompare);

    if (isRequiredField != null || isRequiredFieldCompared != null) {
      return isRequiredField;
    }

    final isValid = field == fieldToCompare;
    return isValid ? null :  R.strings.msgInvalidField;
  }
}
