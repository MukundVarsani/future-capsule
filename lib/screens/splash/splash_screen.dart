import 'package:flutter/material.dart';
import 'package:future_capsule/core/images/images.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
             begin: Alignment.topRight, // Start from the top-right
              end: Alignment.bottomLeft,
            stops: [0.6, 1],
            colors: [
            Color.fromRGBO(137, 207, 240, 1),
            Color.fromRGBO(255, 200, 87, 1),
          ]),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImages.appLogo, height: 250,),

           const SizedBox(
              height: 30,
            ),

            const Text("Preserve Memories, Unlock the Future.",
             style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
             ),)
          ],
        ),
      )
    );
  }
}