import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final Function(String)? onChanged;
  final Widget? suffix;
  final Widget? prefix;
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
    this.prefix,
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
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: prefix,
        hintStyle: const TextStyle(
          fontSize: 12,
        ),
        border: const OutlineInputBorder(),
        helperText: helpText,
        helperStyle: const TextStyle(fontSize: 10),
        errorText: errorText,
        errorStyle: const TextStyle(fontSize: 10, height: 0.9),
        suffixIcon: suffix,
        isDense: true,
      ),
    );
  }
}
