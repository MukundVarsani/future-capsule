import 'package:flutter/material.dart';

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
