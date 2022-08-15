// coverage:ignore-file

import 'package:flutter/material.dart';

class AppTypography {
  static TextStyle? appBarTextTheme(BuildContext context, {Color? color}) =>
      Theme.of(context).textTheme.subtitle1?.copyWith(
          color: color ?? Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600);
}
