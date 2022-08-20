import 'package:auth_app/presentation/controllers/sign_up/sign_up.dart';
import 'package:auth_app/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../../../domain/entities/entities.dart';
import '../../../shared/themes/themes.dart';
import '../../helpers/helpers.dart';
import 'widgets/widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with UIErrorManager {
  late SignUpController controller;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmationPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller = context.read<SignUpController>();
    super.initState();
  }

  @override
  void dispose() {
    // controller.dispose();
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
                  HeaderWidget(
                    height: constraints.maxHeight,
                    assetKey: 'signUpAsset',
                    image: AppImages.signUp,
                    title: R.strings.addAccount,
                  ),
                  FormContainerWidget(
                    height: constraints.maxHeight,
                    emailController: emailController,
                    nameController: nameController,
                    passwordController: passwordController,
                    confirmationPasswordController:
                        confirmationPasswordController,
                  ),
                  ValueListenableBuilder(
                    valueListenable: context.read<SignUpController>(),
                    builder: (context, value, child) {
                      if (value is SignUpSuccess) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/home", (route) => false);
                          });
                        });
                      }

                      if (value is SignUpFailed) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          handleError(context, uiError: value.uiError);
                        });
                      }

                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: value is SignUpLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      final user = UserEntity(
                                          name: nameController.text.trim());

                                      await controller(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          userEntity: user);
                                    }
                                  },
                            child: value is SignUpLoading
                                ? const CircularProgressIndicator(
                                    color: AppColors.white,
                                  )
                                : Text(
                                    R.strings.signup,
                                    style: const TextStyle(
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
                                  key: const Key("signInButton"),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            "/sign_in", (route) => false);
                                  },
                                  child: RichText(
                                    key: const Key("Logar"),
                                    text: TextSpan(
                                        text: R.strings.haveAccount,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.primaryColor,
                                            fontFamily: "Gotham-SSm"),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: ' ${R.strings.login}',
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
