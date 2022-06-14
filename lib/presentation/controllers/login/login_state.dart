part of 'login_controller.dart';

abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {}

class AuthenticationLoading extends LoginState {}

class AuthenticationSuccess extends LoginState {}

class UncompleteAccess extends LoginState {}

class AuthenticationFailed extends LoginState {
  final String error;

  const AuthenticationFailed({required this.error});
}
