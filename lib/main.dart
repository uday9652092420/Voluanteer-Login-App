import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init(); // ✅ Initialize local storage

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Volunteer App',
      debugShowCheckedModeBanner: false,

      // ✅ Use your theme
      theme: AppTheme.lightTheme,

      initialRoute: Routes.LOGIN,

      getPages: AppPages.pages,
    );
  }
}
