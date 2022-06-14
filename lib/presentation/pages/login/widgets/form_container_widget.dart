import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../shared/themes/themes.dart';
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
    return Container(
      margin: EdgeInsets.only(top: widget.height * 0.1),
      child: Column(
        children: [
          CustomTextFormField(
            controller: widget.emailController,
            label: "E-mail",
            textInputType: TextInputType.emailAddress,
            validator: (String? value) =>
                InputValidators.emailFieldValidator(email: value),
          ),
          const SizedBox(
            height: 24,
          ),
          CustomTextFormField(
            controller: widget.passwordController,
            label: "Password",
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
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              alignment: Alignment.centerRight,
              child: Text(
                "Esqueceu a senha?",
                style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            height: widget.height * 0.06,
          )
        ],
      ),
    );
  }
}
