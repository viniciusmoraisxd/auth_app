import 'package:flutter/material.dart';

import '../../../../shared/widgets/widgets.dart';
import '../../../helpers/validators/validators.dart';

class FormContainerWidget extends StatefulWidget {
  final double height;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const FormContainerWidget({
    Key? key,
    required this.height,
    required this.emailController,
    required this.passwordController,
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
          controller: widget.emailController,
          label: "E-mail",
          textInputType: TextInputType.emailAddress,
          prefix: const Icon(Icons.mail_outline),
          validator: (String? value) =>
              InputValidators.emailFieldValidator(email: value),
        ),
        SizedBox(
          height: widget.height * 0.08,
        )
      ],
    );
  }
}
