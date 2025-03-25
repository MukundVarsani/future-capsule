import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {super.key,
      this.controller,
      this.prefixIcon,
      this.border,
      this.enabledBorder,
      this.focusedBorder,
      this.validator,
      this.labelText,
      this.labelStyle,
      this.prefixIconColor,
      this.keyboardType,
      this.suffixIcon,
      this.suffixIconColor,
      this.obscureText});

  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final Widget? suffixIcon;
  final Color? suffixIconColor;
  final bool? obscureText;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        color: AppColors.kWhiteColor,
        fontWeight: FontWeight.w600
      ),
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle ??
            const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color.fromRGBO(53, 153, 219, 1),
            ),
        prefixIconColor:
            prefixIconColor ?? const Color.fromRGBO(53, 153, 219, 1),
        prefixIcon: prefixIcon,
        suffixIconColor:
            suffixIconColor ?? const Color.fromRGBO(53, 153, 219, 1),
        suffixIcon: suffixIcon,
        border: border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color.fromRGBO(53, 153, 219, 1),
              ),
            ),
        enabledBorder: enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color.fromRGBO(53, 153, 219, 1),
              ),
            ),
        focusedBorder: focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color.fromRGBO(53, 153, 219, 1),
              ),
            ),
      ),
      validator: validator,
    );
  }
}
