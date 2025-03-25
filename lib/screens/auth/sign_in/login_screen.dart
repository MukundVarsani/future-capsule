import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/core/widgets/app_button.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/controllers/auth.controller.dart';
import 'package:future_capsule/screens/auth/sign_up/sign_up_page.dart';
import 'package:future_capsule/screens/auth/widgets.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isVisible = false;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      try {
        await _authController.login(
          userEmail: _emailController.text.trim(),
          userPassword: _passwordController.text.trim(),
        );
      } catch (e) {
        appSnackBar(
            context: context,
            text: e.toString(),
            color: AppColors.kErrorSnackBarTextColor,
            textColor: AppColors.kWhiteColor);
      }
    }
  }

  void forgetPassword() {
    if (_emailController.text.isEmpty) {
      appBar(
          text: "Enter registered email to reset password",
          color: AppColors.kErrorSnackBarTextColor,
          textColor: AppColors.kWhiteColor);
      return;
    } else {
      _authController.forgetPassword(email: _emailController.text);
      appSnackBar(
          context: context,
          text: "Reset password link sent to registerd email");
    }
  }

  bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dDeepBackground,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          reverse: true,
          children: [
            SizedBox(
                height: isKeyboardOpen(context)
                    ? MediaQuery.sizeOf(context).height * 0.15
                    : MediaQuery.sizeOf(context).height * 0.3),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    prefixIcon: const Icon(Icons.email),
                    labelText: "Email",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                    AppTextField(
                    labelText: "Password",
                    controller: _passwordController,
                    obscureText: isVisible,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: Icon(
                          !isVisible ? Icons.visibility : Icons.visibility_off),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Sign-Up Button
                  SizedBox(
                    height: 50,
                    child: AppButton(
                      backgroundColor: const Color.fromRGBO(53, 153, 219, 1),
                      onPressed: _handleLogin,
                      child: Obx(() => _authController.isLoading.value
                          ? const CircularProgressIndicator.adaptive(
                              valueColor:
                                  AlwaysStoppedAnimation(AppColors.kWhiteColor),
                            )
                          : const Text(
                              "Sign In",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            )),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have account? ",
                        style: TextStyle(
                            color: AppColors.dInActiveColorPrimary,
                            fontWeight: FontWeight.w600),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: Color.fromRGBO(53, 153, 219, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                          onTap: forgetPassword,
                          child: const Text(
                            "Forget password?",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.kWhiteColor),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Image.asset(AppImages.loginPageImage),
          ],
        ),
      ),
    );
  }
}
