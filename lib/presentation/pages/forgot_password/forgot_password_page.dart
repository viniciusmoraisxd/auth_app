import 'package:auth_app/shared/themes/app_color.dart';
import 'package:flutter/material.dart';

import 'widgets/widgets.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.primaryColor),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            padding:
                EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.06),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  HeaderWidget(height: constraints.maxHeight),
                  FormContainerWidget(
                      height: constraints.maxHeight,
                      emailController: emailController,
                      passwordController: passwordController),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "Enviar",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "Gotham-SSm",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
