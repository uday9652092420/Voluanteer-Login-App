import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter username & password");
      return;
    }

    // Dummy login logic
    if (username == "uday" && password == "12345") {
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      Get.snackbar("Error", "Invalid credentials");
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
