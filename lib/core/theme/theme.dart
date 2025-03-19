import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';

ThemeData kLightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: AppColors.kScreenBackgroundColor,
  ),
);
ThemeData kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.light(
    // surface: Color.fromRGBO(18, 18, 18, 1),
    surface: Color.fromRGBO(188, 24, 24, 1),
   
  ),
);
