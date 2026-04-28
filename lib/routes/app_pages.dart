import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/login_view.dart';
import '../bindings/login_binding.dart'; // ✅ IMPORTANT
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(), // ✅ Now works
    ),

    GetPage(
      name: Routes.DASHBOARD,
      page: () => Scaffold(
        appBar: AppBar(title: Text("Dashboa")),
        body: Center(child: Text("Welcome to Dashboard")),
      ),
    ),
  ];
}
