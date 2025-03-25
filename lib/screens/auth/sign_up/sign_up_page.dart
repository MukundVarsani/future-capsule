import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/images/images.dart';
import 'package:future_capsule/core/widgets/app_button.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/controllers/auth.controller.dart';
import 'package:future_capsule/screens/auth/sign_in/login_screen.dart';
import 'package:future_capsule/screens/auth/widgets.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  bool isVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  bool isKeyboardOpen(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  void handleSignUp() async {
    try {
      if (_formKey.currentState!.validate()) {
        FocusManager.instance.primaryFocus?.unfocus();
        await _authController.createNewUser(
            userEmail: _emailController.text.trim(),
            userPassword: _passwordController.text.trim(),
            userName: _nameController.text.trim());
      }
    } catch (e) {
      Vx.log("Error while handling SignUp : $e");
      appBar(text: e.toString());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                    ? MediaQuery.sizeOf(context).height * 0.05
                    : MediaQuery.sizeOf(context).height * 0.15),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    labelText: "Name",
                    prefixIcon: const Icon(Icons.person),
                    controller: _nameController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your Name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
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
                  AppTextField(
                    labelText: "Confirm Password",
                    controller: _confirmPasswordController,
                    obscureText: isVisible,
                    prefixIcon: const Icon(Icons.lock),
                    validator: (value) {
                      if (value == null ||
                          value != _passwordController.text ||
                          value.isEmpty) {
                        return "Password do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: AppButton(
                      backgroundColor: const Color.fromRGBO(53, 153, 219, 1),
                      onPressed: handleSignUp,
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
                        "Already have an account? ",
                        style: TextStyle(color: AppColors.kWhiteColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Color.fromRGBO(53, 153, 219, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Image.asset(AppImages.signUpPageImage),
          ],
        ),
      ),
    );
  }
}
