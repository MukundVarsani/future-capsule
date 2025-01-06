import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/config/firebase_service.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/screens/home/home_screen.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Timer _timer;

  @override
  void initState() {
    _startUserReloadTimer();
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
        const Text(
          "Verification email has been sent ",
          style: TextStyle(
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
            onPressed: _resendVerificationLink,
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

  void _resendVerificationLink() async {
    await  _auth.currentUser?.sendEmailVerification();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Verification email sent to the registerd email"),
        backgroundColor: Colors.green,
      ),
    );
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
        appSnackBar(context: context, text: "Time out for verification mail");
      }
    });
  }

  void navigateToHomeScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    });
  }
}
