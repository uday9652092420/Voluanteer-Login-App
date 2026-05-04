import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../routes/app_routes.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  final box = GetStorage();

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    /// ✅ Validation
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter username & password");
      return;
    }

    /// 🔥 1. STATIC LOGIN (FIRST PRIORITY)
    if (username == "uday" && password == "12345") {
      print("STATIC LOGIN SUCCESS");

      /// Save dummy token
      box.write("token", "static_token");

      Get.snackbar("Success", "Static Login Success");

      /// Navigate
      Get.offAllNamed(Routes.DASHBOARD);
      return; // ⚠️ STOP here (don’t call API)
    }

    /// 🔥 2. API LOGIN (REAL LOGIN)
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse("http://192.168.1.230:3002/api/qurbani-volunteers/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        /// Save real JWT token
        box.write("token", data["token"]);

        Get.snackbar("Success", "Login successful");

        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.snackbar("Error", data["error"] ?? "Invalid credentials");
      }
    } catch (e) {
      print("ERROR: $e");
      Get.snackbar("Error", "Server not reachable");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
