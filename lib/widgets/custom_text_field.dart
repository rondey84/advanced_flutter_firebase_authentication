import 'package:advanced_flutter_firebase_authentication/core/helper/text_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    this.labelText,
    this.hintText,
    this.borderRadius = 18,
    this.obscureText = false,
    this.passwordVisibilityHandler,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.fillColor,
    this.borderColor,
    this.errorBorderColor,
    this.prefix,
    this.onChanged,
    this.contentPadding,
    this.maxLength,
    this.inputFormatters,
    super.key,
  });

  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final double borderRadius;
  final bool obscureText;
  final VoidCallback? passwordVisibilityHandler;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final Color? borderColor;
  final Color? errorBorderColor;
  final Widget? prefix;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      cursorColor: Get.theme.primaryColor,
      validator: validator,
      style: TextHelper.textFieldTextStyle,
      obscureText: obscureText,
      onChanged: onChanged,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextHelper.textFieldTextStyle.copyWith(
          color: Colors.white54,
        ),
        hintText: hintText,
        hintStyle: TextHelper.textFieldHintTextStyle,
        isDense: true,
        filled: true,
        fillColor: fillColor ?? Colors.white12,
        prefixIcon: prefix,
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
        contentPadding: contentPadding,
        counter: const Offstage(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.white.withOpacity(0.2),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red.withOpacity(0.5),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: errorBorderColor ?? Colors.red.withOpacity(0.5),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
        errorText: null,
        errorStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
      ),
    );
  }
}
