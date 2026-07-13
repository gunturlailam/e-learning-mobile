import 'package:flutter/material.dart';

/// AppColors - Premium UI/UX 2026 Color Palette
class AppColors {
  // Brand Accents
  static const Color primary = Color(0xFF10B981); // Emerald Green
  static const Color primaryDark = Color(0xFF047857); // Deep Green
  static const Color accent = Color(0xFF6366F1); // Indigo Glow
  
  // Neutral Colors
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color white = Colors.white;
  static const Color grey = Color(0xFF64748B); // Slate 500
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  
  // Status Colors
  static const Color softGreen = Color(0xFFECFDF5); // Emerald 50
  static const Color mintGreen = Color(0xFFA7F3D0); // Emerald 200
  static const Color softAmber = Color(0xFFFEF3C7); // Amber 50
  static const Color amber = Color(0xFFD97706); // Amber 600
  static const Color red = Color(0xFFEF4444); // Red 500
  static const Color softRed = Color(0xFFFEE2E2); // Red 50

  // Premium Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient slateGradient = LinearGradient(
    colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
