import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme textTheme(Brightness brightness) {
    final base = (brightness == Brightness.dark)
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;

    final font = GoogleFonts.interTextTheme(base);

    return font.copyWith(
      headlineMedium: font.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
      titleLarge: font.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: font.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: font.bodyLarge?.copyWith(height: 1.35),
      bodyMedium: font.bodyMedium?.copyWith(height: 1.35),
      labelLarge: font.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}
