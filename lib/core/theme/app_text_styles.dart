import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextTheme get textTheme => GoogleFonts.lexendTextTheme();

  static TextStyle get headlineLarge => GoogleFonts.lexend(
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get headlineMedium => GoogleFonts.lexend(
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get titleLarge => GoogleFonts.lexend(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get titleMedium => GoogleFonts.lexend(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get bodyLarge => GoogleFonts.lexend(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get bodyMedium => GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get labelLarge => GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get labelSmall => GoogleFonts.lexend(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
}
