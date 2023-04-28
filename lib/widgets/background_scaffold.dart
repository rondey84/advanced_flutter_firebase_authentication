import 'dart:ui';

import 'package:advanced_flutter_firebase_authentication/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackgroundScaffold extends StatelessWidget {
  const BackgroundScaffold({
    required this.child,
    this.backgroundBlur = 8,
    this.resizeToAvoidBottomInset,
    this.appBar,
    super.key,
  });

  final Widget? child;
  final double backgroundBlur;
  final bool? resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background - Image or fallback to gradient
          Container(
            height: 1.sh,
            width: 1.sw,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(BACKGROUND_ASSET),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
              ),
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  Color(0xFF0F0D13),
                  Color(0xFF423441),
                  Color(0xFF325D93),
                ],
              ),
            ),
          ),
          // Gradient
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: backgroundBlur,
              sigmaY: backgroundBlur,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    const Color(0xFF080B11).withOpacity(1.0),
                    const Color(0xFF080B11).withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          // Child
          SizedBox(height: 1.sh, width: 1.sw, child: child),
        ],
      ),
    );
  }
}
