import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/config/firebase_service.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/widgets/app_button.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/screens/auth/sign_up/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FirebaseService _firebaseService = FirebaseService();

  void signInUser() async {
    try {
      await _firebaseService.login(
        userEmail: _emailController.text,
        userPassword: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      String? error = e.message ?? "Error";

      if ((e.code) == '402') {
        appSnackBar(
            context: context,
            text: error,
            color: AppColors.kErrorSnackBarTextColor,
            textColor: AppColors.kWhiteColor);
      } else {
        appSnackBar(
            context: context,
            text: error,
            color: AppColors.kErrorSnackBarTextColor,
            textColor: AppColors.kWhiteColor);
      }
      rethrow;
    }
  }

  void forgetPassword() {
    if (_emailController.text.isEmpty) {
      appSnackBar(
          context: context,
          text: "Enter registered email to reset password",
          color: AppColors.kErrorSnackBarTextColor,
          textColor: AppColors.kWhiteColor);
      return;
    } else {
      _firebaseService.forgetPassword(email: _emailController.text);

      appSnackBar(
          context: context,
          text: "Reset password link sent to registerd email");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.kWarmCoralColor, AppColors.kAmberColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add_alt_1,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Log In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            signInUser();
                          }
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Already have an account? Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SignUpScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: AppColors.kWarmCoralColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: forgetPassword,
                            child: Text(
                              "Forget password?",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.kBlackColor),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
