import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import '../../../shared/themes/themes.dart';
import '../../controllers/sign_in/sign_in.dart';
import '../../helpers/helpers.dart';
import 'widgets/widgets.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with UIErrorManager {
  late SignInController controller;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller = context.read<SignInController>();
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
                  HeaderWidget(height: constraints.maxHeight),
                  FormContainerWidget(
                      height: constraints.maxHeight,
                      emailController: emailController,
                      passwordController: passwordController),
                  ValueListenableBuilder(
                    valueListenable: context.read<SignInController>(),
                    builder: (context, value, child) {
                      if (value is SignInSuccess) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, "/home", (route) => false);
                        });
                      }

                      if (value is SignInFailed) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          handleError(context, uiError: value.uiError);
                        });
                      }

                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: value is SignInLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      await controller(
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  },
                            child: value is SignInLoading
                                ? const CircularProgressIndicator(
                                    color: AppColors.white,
                                  )
                                : Text(
                                    R.strings.enter,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: "Gotham-SSm",
                                    ),
                                  ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: constraints.maxHeight * 0.09),
                            child: Column(
                              children: [
                                // const SizedBox(height: 6),
                                GestureDetector(
                                  key: const Key("signupButton"),
                                  onTap: () {
                                    Navigator.of(context).pushNamed("/sign_up");
                                  },
                                  child: RichText(
                                    key: const Key("Registre-se"),
                                    text: TextSpan(
                                        text: R.strings.dontHaveAccount,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.primaryColor,
                                            fontFamily: "Gotham-SSm"),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: " ${R.strings.addAccount}",
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
