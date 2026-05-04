// import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/login_view.dart';
import '../bindings/login_binding.dart';

import '../views/dashboard_view.dart'; // ✅ added
import '../bindings/dashboard_binding.dart'; // ✅ added

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
  ];
}
