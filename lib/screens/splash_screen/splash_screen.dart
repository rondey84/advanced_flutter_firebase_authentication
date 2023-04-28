import 'package:advanced_flutter_firebase_authentication/widgets/background_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

part 'splash_controller.dart';
part 'splash_bindings.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      child: Center(
        child: SpinKitRipple(
          color: Colors.white30,
          size: 0.2.sw,
        ),
      ),
    );
  }
}
