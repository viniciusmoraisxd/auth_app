// coverage:ignore-file

import 'package:flutter/material.dart';

import 'app_color.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    fontFamily:"Gotham-SSm",
      useMaterial3: false,
      primarySwatch: AppColors.primaryCustomColor,
      appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          iconTheme: const IconThemeData(color: AppColors.white)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          primary: AppColors.primaryColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: BorderSide(
            color: AppColors.primaryColor,
          ),
          primary: AppColors.primaryColor,
        ),
      ));
}
