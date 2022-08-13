import 'package:flutter/material.dart';

import '../../../shared/themes/themes.dart';
import '../errors/errors.dart';

mixin UIErrorManager {
  void handleError(BuildContext context, {required UIError uiError}) {
    final snackBar = SnackBar(
      content: Text(uiError.description),
      backgroundColor: AppColors.errorBackgroundColor,
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
