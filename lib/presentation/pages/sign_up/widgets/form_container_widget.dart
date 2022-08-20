import 'package:auth_app/presentation/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../shared/widgets/widgets.dart';

class FormContainerWidget extends StatefulWidget {
  final double height;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmationPasswordController;
  const FormContainerWidget({
    Key? key,
    required this.height,
    required this.emailController,
    required this.passwordController,
    required this.confirmationPasswordController,
    required this.nameController,
  }) : super(key: key);

  @override
  State<FormContainerWidget> createState() => _FormContainerWidgetState();
}

class _FormContainerWidgetState extends State<FormContainerWidget> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          controller: widget.nameController,
          label: R.strings.name,
          textInputType: TextInputType.name,
          prefix: const Icon(Icons.person_outline),
          validator: (String? value) =>
              InputValidators.requiredFieldValidator(value: value),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomTextFormField(
          controller: widget.emailController,
          label: R.strings.email,
          textInputType: TextInputType.emailAddress,
          prefix: const Icon(Icons.mail_outline),
          validator: (String? value) =>
              InputValidators.emailFieldValidator(email: value),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomTextFormField(
          controller: widget.passwordController,
          prefix: const Icon(
            Icons.lock_outline,
          ),
          label: R.strings.password,
          obscureText: obscurePassword,
          validator: (String? value) =>
              InputValidators.requiredFieldValidator(value: value),
          suffix: IconButton(
            icon: Icon(obscurePassword ? Ionicons.eye_off : Ionicons.eye),
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        CustomTextFormField(
          prefix: const Icon(
            Icons.lock_outline,
          ),
          label: R.strings.repeatPassword,
          obscureText: obscurePassword,
          validator: (String? value) => InputValidators.compareFieldsValidator(
              fieldToCompare: widget.passwordController.text, field: value),
          suffix: IconButton(
            icon: Icon(obscurePassword ? Ionicons.eye_off : Ionicons.eye),
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
          ),
        ),
        SizedBox(
          height: widget.height * 0.04,
        )
      ],
    );
  }
}
