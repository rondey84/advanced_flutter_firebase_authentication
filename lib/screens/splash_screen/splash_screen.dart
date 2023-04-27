import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'splash_controller.dart';
part 'splash_bindings.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
