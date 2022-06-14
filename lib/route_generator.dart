import 'package:flutter/material.dart';

import 'presentation/pages/pages.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignUpPage());

      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}
