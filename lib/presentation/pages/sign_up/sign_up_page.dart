import 'dart:developer';

import 'package:auth_app/presentation/controllers/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../../shared/themes/themes.dart';
import 'widgets/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late SignUpController controller;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller = context.read<SignUpController>();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
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
                  ValueListenableBuilder(
                    valueListenable: context.read<SignUpController>(),
                    builder: (context, value, child) {
                      if (value is SignUpSuccess) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          log("Success Register");
                        });
                      }

                      if (value is SignUpFailed) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          showSimpleNotification(
                              const Text(
                                "Ops!",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.white,
                                    fontSize: 14),
                              ),
                              background: Colors.red.shade400,
                              duration: const Duration(seconds: 5),
                              subtitle: Text(
                                value.error,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.white,
                                    fontSize: 12),
                              ));
                        });
                      }

                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: value is SignUpLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      await controller.remoteSignUp(
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  },
                            child: value is SignUpLoading
                                ? const CircularProgressIndicator(
                                    color: AppColors.white,
                                  )
                                : const Text(
                                    "Registrar",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: "Gotham-SSm",
                                    ),
                                  ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: constraints.maxHeight * 0.04),
                            child: Column(
                              children: [
                                // const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'Já tem uma conta?',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.primaryColor,
                                            fontFamily: "Gotham-SSm"),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: ' Logar',
                                              style: TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600)),
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
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
