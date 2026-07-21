import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F0F0F),
      primaryColor: AppColors.accent,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFD7A15D),
        secondary: Color(0xFFC78B3A),
        surface: Color(0xFF181818),
        error: Color(0xFFE53935),
      ),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
      cardTheme: CardThemeData(color: const Color(0xFF181818), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      primaryColor: const Color(0xFFD7A15D),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFD7A15D),
        secondary: Color(0xFFC78B3A),
        surface: Colors.white,
        error: Color(0xFFE53935),
      ),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, centerTitle: true, foregroundColor: Colors.black),
      cardTheme: CardThemeData(color: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    );
  }
}
