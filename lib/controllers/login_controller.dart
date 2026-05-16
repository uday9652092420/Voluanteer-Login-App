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

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter username & password");
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse("http://192.168.1.230:3002/api/qurbani-volunteers/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        /// ✅ CORRECT DATA PATH
        final loginData = json["data"];

        /// ✅ SAVE TOKEN
        await box.write("token", loginData["accessToken"]);

        /// ✅ SAVE VOLUNTEER
        await box.write("volunteer", loginData["volunteer"]);

        print("TOKEN: ${box.read("token")}");
        print("VOLUNTEER: ${box.read("volunteer")}");

        Get.snackbar("Success", "Login successful");

        Get.offAllNamed(Routes.DASHBOARD);
      } else {
        Get.snackbar("Error", json["message"] ?? "Invalid credentials");
      }
    } catch (e) {
      print("LOGIN ERROR: $e");

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
