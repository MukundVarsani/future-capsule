import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';

class CustomPicker extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const  CustomPicker({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    Color? backgroundColor, 
    Color? iconColor, 
    Color? textColor, 
  })  : backgroundColor = backgroundColor ?? AppColors.kWarmCoralColor,
        iconColor = iconColor ?? AppColors.kWhiteColor,
        textColor = textColor ?? AppColors.kBlackColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 40,
            ),
          ),
        ),
        Text(
          label,
          style: TextStyle(color: textColor),
        ),
      ],
    );
  }
}
