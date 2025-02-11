import 'package:flutter/material.dart';
import 'package:get/get.dart';


 appSnackBar({
  required BuildContext context,
  required String text,
  Duration duration = const Duration(seconds: 2),
  Color color = const  Color.fromRGBO(32, 201, 151,1),
  Color textColor = const  Color.fromRGBO(255, 255, 255,1)
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      duration:  duration,
      content: Text(
        text,

        style:  TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w400
        ),
      ),
      backgroundColor: color,
    ),
  );
}


appBar(
    {required String text,
    Duration duration = const Duration(seconds: 2),
    Color color = const  Color.fromRGBO(32, 201, 151,1),
    Color textColor = const Color.fromRGBO(255, 255, 255, 1)}) {
  return Get.snackbar(
    "",
    '',
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
    margin:const  EdgeInsets.symmetric(horizontal: 20),
    duration: duration,
    backgroundColor: color,
    titleText: Text(
      text,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
    ),
    snackPosition: SnackPosition.BOTTOM,
  );
}