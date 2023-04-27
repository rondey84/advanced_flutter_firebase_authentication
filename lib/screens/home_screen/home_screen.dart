import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'home_controller.dart';
part 'home_bindings.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
