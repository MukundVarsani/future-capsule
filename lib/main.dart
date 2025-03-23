import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:future_capsule/data/controllers/capsule.controller.dart';
import 'package:future_capsule/data/services/notification_service.dart';
import 'package:future_capsule/screens/auth/sign_in/login_screen.dart';
import 'package:future_capsule/screens/auth/sign_in/sign_in_screen.dart';
import 'package:future_capsule/screens/auth/verification/verification_screen.dart';
import 'package:future_capsule/screens/bottom_navigation_bar.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBOfe_iSxGMg4XHKWUgvt-7grks5UyC4kc",
      appId: "1:521138022480:android:5cbd49520ad1258a58c955",
      messagingSenderId: "521138022480",
      projectId: "grocerry-app-2fb25",
      storageBucket: "grocerry-app-2fb25.appspot.com",
    ),
  );
  Get.put(CapsuleController());
  final NotificationService notificationService = NotificationService();
  notificationService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),

      home: _getLandingPage(_auth),
    );
  }
}

Widget _getLandingPage(FirebaseAuth auth) {
  return StreamBuilder<User?>(
    stream: auth.authStateChanges(),
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data?.providerData.length == 1) {
          return snapshot.data!.emailVerified
              ? const BottomBar()
              : VerificationScreen(verificationEmail: snapshot.data!.email!);
        } else {
          return const BottomBar();
        }
      } else {
        return const LoginScreen();
      }
    },
  );
}
