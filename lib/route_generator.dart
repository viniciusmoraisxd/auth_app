import 'package:auth_app/presentation/pages/forgot_password/forgot_password.dart';
import 'package:flutter/material.dart';
import 'presentation/pages/pages.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/sign_in':
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case '/sign_up':
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case '/forgot_password':
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(builder: (_) => const SignInPage());
    }
  }
}
