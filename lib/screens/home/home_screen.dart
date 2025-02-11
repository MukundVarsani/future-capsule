import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:future_capsule/core/widgets/snack_bar.dart';
import 'package:future_capsule/data/controllers/auth.controller.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController _authController = Get.put(AuthController());
  User? user;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          this.user = user;
        });
      }
    });
  }

  @override
  void dispose() {
    user?.delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: (user != null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _signOut,
                    child: const Text("Sign out"),
                  ),
                  Text(user!.email.toString()),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void _signOut() async {
    try {
      await _authController.signOut();
    } catch (e) {
      appBar(text: e.toString());
    }
  }
}
