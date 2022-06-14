class InputValidators {
  static String? requiredFieldValidator({String? value}) {
    return value?.isNotEmpty == true ? null : "Campo obrigatório.";
  }

  static String? emailFieldValidator({String? email}) {
    final isRequiredField = requiredFieldValidator(value: email);

    if (isRequiredField != null) return isRequiredField;

    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    final isValid = email?.isNotEmpty != true || regex.hasMatch(email!);
    return isValid ? null : "E-mail inválido.";
  }
}
