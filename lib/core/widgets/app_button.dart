import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';

class AppButton extends StatelessWidget {
 const AppButton({
    super.key,
    required this.child,
    required this.onPressed,
    Color? backgroundColor,
    this.radius = 12,
  }) : backgroundColor = backgroundColor ?? AppColors.kWarmCoralColor;

  final Widget child;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          backgroundColor:backgroundColor,
          elevation: 0,
          padding: const EdgeInsets.all(10),
        ),
        child: child,
      ),
    );
  }
}
