import 'package:advanced_flutter_firebase_authentication/core/helper/text_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.onTap,
    this.child,
    this.text,
    this.borderRadius = 16,
    this.maxHeight = 46,
    this.maxWidth = double.infinity,
    super.key,
  });

  final VoidCallback? onTap;
  final Widget? child;
  final String? text;

  final double borderRadius;
  final double maxHeight;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: Get.theme.primaryColor,
        splashFactory: InkRipple.splashFactory,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Get.theme.primaryColor.withOpacity(0.4),
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              colors: [
                Get.theme.primaryColor.withOpacity(0.26),
                Get.theme.primaryColor.withOpacity(0.10),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
          alignment: Alignment.center,
          child: child ??
              (text != null
                  ? Text(
                      text!,
                      textAlign: TextAlign.center,
                      style: TextHelper.buttonTextStyle,
                    )
                  : null),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.onTap,
    this.child,
    this.text,
    this.borderRadius = 16,
    this.maxHeight = 46,
    this.maxWidth = double.infinity,
    super.key,
  });

  final VoidCallback? onTap;
  final Widget? child;
  final String? text;

  final double borderRadius;
  final double maxHeight;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: Get.theme.primaryColor,
        splashFactory: InkRipple.splashFactory,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.white.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white.withOpacity(0.07),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
          alignment: Alignment.center,
          child: child ??
              (text != null
                  ? Text(
                      text!,
                      textAlign: TextAlign.center,
                      style: TextHelper.buttonTextStyle,
                    )
                  : null),
        ),
      ),
    );
  }
}

class ElevatedGradButton extends StatelessWidget {
  const ElevatedGradButton({
    required this.onTap,
    this.child,
    this.text,
    this.maxHeight = 46,
    super.key,
  });

  final VoidCallback? onTap;
  final Widget? child;
  final String? text;

  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const StadiumBorder(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            gradient: LinearGradient(
              colors: [
                Get.theme.primaryColorLight,
                Get.theme.primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: BoxConstraints(maxHeight: maxHeight),
          alignment: Alignment.center,
          child: child ??
              (text != null
                  ? Text(
                      text!,
                      textAlign: TextAlign.center,
                      style: TextHelper.buttonTextStyle,
                    )
                  : null),
        ),
      ),
    );
  }
}
