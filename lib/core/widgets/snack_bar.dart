import 'package:flutter/material.dart';

appSnackBar({
  required BuildContext context,
  required String text,
  Duration duration = const Duration(seconds: 2),
  Color color = Colors.green
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration:  duration,
      content: Text(
        text,
      ),
      backgroundColor: color,
    ),
  );
}
