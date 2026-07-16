import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Títulos
  static const TextStyle title = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle titleSmall = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  
  // Subtítulos
  static const TextStyle subtitle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  
  // Cuerpo
  static const TextStyle body = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
  );
  
  static const TextStyle bodySmall = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
  );
  
  // Botones
  static const TextStyle button = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  
  // Navegación
  static const TextStyle navLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
  
  // Precios
  static const TextStyle price = TextStyle(
    color: AppColors.accent,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  
  // Badge
  static const TextStyle badge = TextStyle(
    color: Colors.white,
    fontSize: 9,
    fontWeight: FontWeight.bold,
  );
}
