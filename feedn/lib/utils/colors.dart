import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF006C49);
  static const Color primaryContainer = Color(0xFF10B981);
  static const Color background = Color(0xFFFAF9F8);
  static const Color surface = Color(0xFFFAF9F8);
  static const Color onSurface = Color(0xFF1A1C1C);
  static const Color onSurfaceVariant = Color(0xFF3C4A42);
  static const Color outlineVariant = Color(0xFFBBCABF);
  static const Color surfaceContainerLow = Color(0xFFF4F3F2);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF9D4300);
  static const Color secondaryContainer = Color(0xFFFD761A);
  
  // Custom Gradients and shadows configuration helper if needed
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryContainer],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static List<BoxShadow> cloudShadow = [
    BoxShadow(
      color: onSurface.withOpacity(0.04),
      blurRadius: 32,
      offset: const Offset(0, 16),
    ),
  ];
}
