import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';


class AnimatedToggle extends StatelessWidget {
  const AnimatedToggle(
      {super.key,
      required this.isToggled,
      required this.onIcon,
      required this.offIcon,
      this.backgroundColor = AppColors.kWarmCoralColor});
  final bool isToggled;
  final IconData onIcon;
  final IconData offIcon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 70,
      height: 35,
      decoration: BoxDecoration(
        color: isToggled ? backgroundColor : AppColors.kLightBlackColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isToggled
            ?  [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: backgroundColor.withOpacity(0.7), // Glow effect
                  blurRadius: 10,
                  spreadRadius: 3,
                ),
              ]
            : [],
      ),
      child: Row(
        mainAxisAlignment:
            isToggled ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          const SizedBox(width: 5),
          if (!isToggled)
            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              decoration: BoxDecoration(
                  color: AppColors.dActiveColorSecondary,
                  borderRadius: BorderRadius.circular(50)),
              padding: const EdgeInsets.all(4),
              child: Icon(offIcon, color: AppColors.kLightBlackColor, size: 20),
            ),
          if (isToggled)
            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              decoration: BoxDecoration(
                  color: AppColors.kWhiteColor,
                  borderRadius: BorderRadius.circular(50)),
              padding: const EdgeInsets.all(4),
              child: Icon(onIcon, color: backgroundColor, size: 20),
            ),
          const SizedBox(width: 5), 
        ],
      ),
    );
  }
}
