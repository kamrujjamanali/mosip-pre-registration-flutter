import 'package:flutter/material.dart';

class AppTheme {
  static const primaryPink = Color(0xFFFE528D);

  static ThemeData theme = ThemeData(
    primaryColor: primaryPink,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryPink,
      primary: primaryPink,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      floatingLabelStyle: TextStyle(color: primaryPink),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryPink),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryPink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    ),
  );
}
