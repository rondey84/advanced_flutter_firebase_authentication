import 'package:advanced_flutter_firebase_authentication/core/helper/text_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.borderRadius = 18,
    this.obscureText = false,
    this.passwordVisibilityHandler,
    this.textInputAction,
    this.keyboardType,
    super.key,
  });

  final TextEditingController controller;
  final String labelText;
  final double borderRadius;
  final bool obscureText;
  final VoidCallback? passwordVisibilityHandler;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      cursorColor: Get.theme.primaryColor,
      style: TextHelper.textFieldTextStyle,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextHelper.textFieldTextStyle.copyWith(
          color: Colors.white54,
        ),
        isDense: true,
        filled: true,
        fillColor: Colors.white12,
        suffixIcon: passwordVisibilityHandler != null
            ? IconButton(
                onPressed: passwordVisibilityHandler,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.white.withOpacity(0.35),
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.red.withOpacity(0.3),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ),
    );
  }
}
