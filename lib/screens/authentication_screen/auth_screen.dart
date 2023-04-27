import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'auth_controller.dart';
part 'auth_bindings.dart';

class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
