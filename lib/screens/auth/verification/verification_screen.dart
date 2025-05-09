import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/controllers/auth.controller.dart';
import 'package:future_capsule/screens/auth/sign_in/login_screen.dart';
import 'package:future_capsule/screens/bottom_navigation_bar.dart';
import 'package:get/get.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.verificationEmail});
  final String verificationEmail;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final AuthController _authController = Get.put(AuthController());

  late Timer _timer;

  @override
  void initState() {
    _startUserReloadTimer();
    _sendVerificationLink();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: const Text(
          "Email verification",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(
          width: double.infinity,
          height: 50,
        ),
        Text(
          "Verification email has been sent to:\n ${widget.verificationEmail}",
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        Text(
          "verify email",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.blue[900]),
        ),
        const SizedBox(
          height: 50,
        ),
        ElevatedButton(
            onPressed: _sendVerificationLink,
            child: const Text(
              "Resend verification email",
            )),
        const SizedBox(
          height: 50,
        ),
      ]),
    );
  }

  // Screen use method

  void _sendVerificationLink() async {
    try {
      await _authController.sendEmailVerification();

      appBar(
        text: "Verification email sent to the registerd email",
      );
    } catch (e) {
      appBar(text: e.toString());
      Get.to(const LoginScreen());
    }
  }

  void _startUserReloadTimer() {
    const totalDuration = Duration(minutes: 2);
    const intervalDuration = Duration(seconds: 3);

    // Track elapsed time
    Duration elapsed = Duration.zero;

    _timer = Timer.periodic(intervalDuration, (timer) async {
      elapsed += intervalDuration;

      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload(); // Reload user data
        if (user.emailVerified) {
          timer.cancel();
          navigateToHomeScreen();
          appSnackBar(context: context, text: "Email Verified");
          return;
        }
      }

      // Stop the timer after 2 minutes if email is not verified
      if (elapsed >= totalDuration) {
        timer.cancel();
        appSnackBar(
            context: context,
            text: "Time out for verification mail",
            color: AppColors.kErrorSnackBarTextColor,
            textColor: AppColors.kWhiteColor,
            duration: const Duration(minutes: 1));
      }
    });
  }

  void navigateToHomeScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      Get.to(const BottomBar());
    });
  }
}
