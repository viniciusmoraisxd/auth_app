import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../themes/themes.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final Function(String)? onChanged;
  final Widget? suffix;
  final TextInputType? textInputType;
  final bool? enabled;
  final bool? obscureText;
  final int? maxLength;
  final String? errorText;
  final String? helpText;
  final String? prefixText;
  final String? initialText;
  final List<TextInputFormatter>? inputFormatters;

  final String? Function(String?)? validator;

  const CustomTextFormField({
    Key? key,
    required this.label,
    this.onChanged,
    this.suffix,
    this.textInputType,
    this.enabled,
    this.maxLength,
    this.errorText,
    this.obscureText,
    this.controller,
    this.helpText,
    this.prefixText,
    this.initialText,
    this.inputFormatters,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      initialValue: initialText,
      controller: initialText == null ? controller : null,
      onChanged: onChanged,
      keyboardType: textInputType,
      obscureText: obscureText ?? false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      decoration: InputDecoration(
        prefixText: prefixText,
        label: Text(
          label,
          style: const TextStyle(color: AppColors.grey),
        ),
        // labelStyle: AppTypography.customTextFormLabel(),
        helperText: helpText,
        helperStyle: const TextStyle(fontSize: 10),
        errorText: errorText,
        suffixIcon: suffix,
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }
}
