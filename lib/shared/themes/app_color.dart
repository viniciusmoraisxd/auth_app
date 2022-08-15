// coverage:ignore-file

import 'package:flutter/material.dart';

class AppColors {
  static MaterialColor primaryCustomColor =
      MaterialColor(0xFF1A1A1A, customColor);

  static Color primaryColor = const Color(0xFF1A1A1A);
  static Color accentColor = const Color(0xFFFFC727);

  static Color cardBackgroundColor = const Color(0xFFF0f1f5);
  static MaterialAccentColor errorBackgroundColor = Colors.redAccent;

  static const Color black = Colors.black;
  static const Color black54 = Colors.black54;
  static const Color black87 = Colors.black87;
  static const Color grey = Colors.grey;
  static const Color backgroundLogin = Color(0xFF212121);

  static const Color white = Colors.white;
}

Map<int, Color> customColor = {
  50: const Color.fromRGBO(26, 26, 26, 0.1),
  100: const Color.fromRGBO(26, 26, 26, 0.2),
  200: const Color.fromRGBO(26, 26, 26, 0.3),
  300: const Color.fromRGBO(26, 26, 26, 0.4),
  400: const Color.fromRGBO(26, 26, 26, 0.5),
  500: const Color.fromRGBO(26, 26, 26, 0.6),
  600: const Color.fromRGBO(26, 26, 26, 0.7),
  700: const Color.fromRGBO(26, 26, 26, 0.8),
  800: const Color.fromRGBO(26, 26, 26, 0.9),
  900: const Color.fromRGBO(26, 26, 26, 1),
};
