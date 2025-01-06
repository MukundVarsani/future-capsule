import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';

class AnimatedToggle extends StatelessWidget {
  const AnimatedToggle({super.key, required this.isToggled, required this.onIcon, required this.offIcon});
  final bool isToggled;
  final IconData onIcon;
  final IconData offIcon;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 80,
      height: 40,
      decoration: BoxDecoration(
        color:
            isToggled ? AppColors.kWarmCoralColor : AppColors.kLightGreyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment:
            isToggled ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          const SizedBox(width: 5),
          if (!isToggled)
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                  color: AppColors.kWhiteColor,
                  borderRadius: BorderRadius.circular(50)),
              padding: const EdgeInsets.all(4),
              child:
                  Icon(offIcon, color: AppColors.kLightGreyColor, size: 24),
            ),
          if (isToggled)
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                  color: AppColors.kWhiteColor,
                  borderRadius: BorderRadius.circular(50)),
              padding: const EdgeInsets.all(4),
              child: Icon(onIcon,
                  color: AppColors.kWarmCoralColor, size: 24),
            ),
          const SizedBox(width: 5), // Add space between icon and border
        ],
      ),
    );
  }
}
