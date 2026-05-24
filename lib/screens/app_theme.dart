import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Palette
  static const Color navy = Color(0xFF0A192F);
  static const Color navyLight = Color(0xFF112240);
  static const Color blue = Color(0xFF0066D4);
  static const Color blueLight = Color(0xFF1E7FE8);

  // Neutral
  static const Color black = Color(0xFF0D0D0D);
  static const Color charcoal = Color(0xFF1A1A1A);
  static const Color darkGrey = Color(0xFF333333);
  static const Color medGrey = Color(0xFF888888);
  static const Color lightGrey = Color(0xFFB8B8B8);
  static const Color offWhite = Color(0xFFF8F8F6);
  static const Color white = Color(0xFFFFFFFF);

  // Accent
  static const Color gold = Color(0xFFD4A853);
  static const Color crimson = Color(0xFFCC2936);
  static const Color success = Color(0xFF2ECC71);

  // Surface
  static const Color surface = Color(0xFFF6F5F3);
  static const Color cardBg = Color(0xFFFAFAF9);
  static const Color border = Color(0xFFE8E8E6);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: const ColorScheme.light(
        primary: AppColors.black,
        secondary: AppColors.blue,
        surface: AppColors.white,
        error: AppColors.crimson,
      ),
      textTheme: GoogleFonts.montserratTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.black, size: 22),
        titleTextStyle: TextStyle(
          color: AppColors.black,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.5,
        ),
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 11,
            letterSpacing: 2,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.black, width: 1.5),
        ),
        labelStyle: const TextStyle(color: AppColors.medGrey, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.black,
        contentTextStyle: GoogleFonts.montserrat(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}