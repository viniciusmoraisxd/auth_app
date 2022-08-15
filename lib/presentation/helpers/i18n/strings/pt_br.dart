import 'translations.dart';

class PtBr implements Translations {
  @override
  String get msgEmailInUse => "O e-mail já está em uso";

  @override
  String get msgInvalidCredentials => "Credenciais inválidas";

  @override
  String get msgInvalidField => "Campo inválido";

  @override
  String get msgRequiredField => "Campo obrigatório";

  @override
  String get msgUnexpectedError =>
      "Algo errado aconteceu. Tente novamente em breve!";

  @override
  String get addAccount => 'Criar conta';

  @override
  String get confirmPassword => "Confirmar senha";

  @override
  String get email => "E-mail";

  @override
  String get enter => "Entrar";

  @override
  String get signup => "Registrar";

  @override
  String get login => "Login";

  @override
  String get password => "Senha";

  @override
  String get reload => "Recarregar";

  @override
  String get surveys => "Enquetes";

  @override
  String get name => "Seu nome";

  @override
  String get wait => "Aguarde";

  @override
  String get msgUserDisabled => "Este usuário está desabilitado";

  @override
  String get msgUserNotFound => "Usuário não encontrado";

  @override
  String get msgWeakPassword => "Senha fraca";

  @override
  String get forgotPassword => "Esqueceu a senha?";

  @override
  String get dontHaveAccount => "Não tem uma conta?";

  @override
  String get haveAccount => "Já tem uma conta?";

  @override
  String get msgInvalidEmail => "E-mail inválido";

  @override
  String get repeatPassword => "Repita sua senha";
}
