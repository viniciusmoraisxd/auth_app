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
        return "Campo obrigatório.";

      case UIError.invalidField:
        return "Campo inválido.";

      case UIError.invalidCredentials:
        return "Credenciais inválidas.";

      case UIError.emailInUse:
        return "O e-mail já está em uso.";

      case UIError.userDisabled:
        return "Este usuário está desabilitado.";

      case UIError.userNotFound:
        return "Usuário não encontrado.";

      case UIError.weakPassword:
        return "Senha fraca.";

      default:
        return "Algo de errado aconteceu!";
    }
  }
}
