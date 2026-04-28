import 'package:flutter/material.dart';

/// 🎨 App Colors (Simplified)
class AppColors {
  // Primary Theme Colors
  static const Color primary = Color.fromARGB(255, 12, 183, 235); // Sky Blue
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Background
  static const Color background = Colors.white;

  // Text Colors
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Colors.grey;

  // Status Colors
  static const Color success = Colors.green;
  static const Color error = Colors.red;
}

/// 🌈 App Theme
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Montserrat',

    // 🔹 Primary Colors
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,

    // 🔹 AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
    ),

    // 🔹 Text Theme
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
    ),

    // 🔹 Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // 🔹 Input Field Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),

    // 🔹 Color Scheme (important for Material 3)
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      background: AppColors.background,
    ),
  );
}
