import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography System - Modern & Readable
/// Using Inter font family for clean, professional look
class AppTextStyles {
  // Font Family
  static TextStyle get _baseStyle => GoogleFonts.inter();
  
  // Display Styles - For hero sections
  static TextStyle displayLarge(BuildContext context) => _baseStyle.copyWith(
    fontSize: 57,
    fontWeight: FontWeight.w800,
    height: 1.12,
    letterSpacing: -0.25,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  static TextStyle displayMedium(BuildContext context) => _baseStyle.copyWith(
    fontSize: 45,
    fontWeight: FontWeight.w700,
    height: 1.16,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  static TextStyle displaySmall(BuildContext context) => _baseStyle.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 1.22,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  // Headline Styles - For section headers
  static TextStyle headlineLarge(BuildContext context) => _baseStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  static TextStyle headlineMedium(BuildContext context) => _baseStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.29,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  static TextStyle headlineSmall(BuildContext context) => _baseStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  // Title Styles - For card titles
  static TextStyle titleLarge(BuildContext context) => _baseStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.27,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  static TextStyle titleMedium(BuildContext context) => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.15,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  static TextStyle titleSmall(BuildContext context) => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.1,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  // Body Styles - For content
  static TextStyle bodyLarge(BuildContext context) => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  static TextStyle bodyMedium(BuildContext context) => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  static TextStyle bodySmall(BuildContext context) => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  // Label Styles - For buttons and labels
  static TextStyle labelLarge(BuildContext context) => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: 0.1,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  static TextStyle labelMedium(BuildContext context) => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0.5,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  static TextStyle labelSmall(BuildContext context) => _baseStyle.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.5,
    color: Theme.of(context).colorScheme.onBackground,
  );
  
  // Custom Styles
  static TextStyle button(BuildContext context) => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.5,
    color: Colors.white,
  );
  
  static TextStyle caption(BuildContext context) => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
  );
  
  static TextStyle overline(BuildContext context) => _baseStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.6,
    letterSpacing: 1.5,
    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
  );
}
