import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ## NEW: Updated color palette ##
class LightModeColors {
  static const lightPrimary = Color(0xFFFF6F00); // Vibrant orange
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightSecondary = Color(0xFFFFB300); // Lighter, yellowish orange
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightTertiary = Color(0xFFD22B2B); // Kept your red for accents
  static const lightOnTertiary = Color(0xFFFFFFFF);
  static const lightError = Color(0xFFB00020);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightSurface = Color(0xFFF5F5F5); // Light grey for backgrounds
  static const lightOnSurface = Color(0xFF212121); // Dark text
}

// Your original DarkModeColors
class DarkModeColors {
  static const darkPrimary = Color(0xFFD4BCCF);
  static const darkOnPrimary = Color(0xFF38265C);
  static const darkPrimaryContainer = Color(0xFF4F3D74);
  static const darkOnPrimaryContainer = Color(0xFFEAE0FF);
  static const darkSecondary = Color(0xFFCDC3DC);
  static const darkOnSecondary = Color(0xFF34313F);
  static const darkTertiary = Color(0xFFF0B6C5);
  static const darkOnTertiary = Color(0xFF4A2530);
  static const darkError = Color(0xFFFFB4AB);
  static const darkOnError = Color(0xFF690005);
  static const darkErrorContainer = Color(0xFF93000A);
  static const darkOnErrorContainer = Color(0xFFFFDAD6);
  static const darkInversePrimary = Color(0xFF684F8E);
  static const darkShadow = Color(0xFF000000);
  static const darkSurface = Color(0xFF121212);
  static const darkOnSurface = Color(0xFFE0E0E0);
  static const darkAppBarBackground = Color(0xFF4F3D74);
}

// Your original FontSizes
class FontSizes {
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 24.0;
  static const double headlineSmall = 22.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 18.0;
  static const double titleSmall = 16.0;
  static const double labelLarge = 16.0;
  static const double labelMedium = 14.0;
  static const double labelSmall = 12.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

// ## NEW: Updated ThemeData for Light Mode ##
ThemeData get lightTheme => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: LightModeColors.lightPrimary,
        primary: LightModeColors.lightPrimary,
        secondary: LightModeColors.lightSecondary,
        surface: LightModeColors.lightSurface,
        onPrimary: LightModeColors.lightOnPrimary,
        onSecondary: LightModeColors.lightOnSecondary,
        onSurface: LightModeColors.lightOnSurface,
        tertiary: LightModeColors.lightTertiary,
        onTertiary: LightModeColors.lightOnTertiary,
        error: LightModeColors.lightError,
        onError: LightModeColors.lightOnError,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: LightModeColors.lightPrimary,
        foregroundColor: LightModeColors.lightOnPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: LightModeColors.lightOnPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LightModeColors.lightPrimary,
          foregroundColor: LightModeColors.lightOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle:
              GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: LightModeColors.lightPrimary,
          side: BorderSide(color: LightModeColors.lightPrimary, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle:
              GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: LightModeColors.lightSecondary, width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey[600]),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ).apply(
        bodyColor: LightModeColors.lightOnSurface,
        displayColor: LightModeColors.lightOnSurface,
      ),
    );

// Your original dark theme getter
ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: DarkModeColors.darkPrimary,
        onPrimary: DarkModeColors.darkOnPrimary,
        primaryContainer: DarkModeColors.darkPrimaryContainer,
        onPrimaryContainer: DarkModeColors.darkOnPrimaryContainer,
        secondary: DarkModeColors.darkSecondary,
        onSecondary: DarkModeColors.darkOnSecondary,
        tertiary: DarkModeColors.darkTertiary,
        onTertiary: DarkModeColors.darkOnTertiary,
        error: DarkModeColors.darkError,
        onError: DarkModeColors.darkOnError,
        errorContainer: DarkModeColors.darkErrorContainer,
        onErrorContainer: DarkModeColors.darkOnErrorContainer,
        inversePrimary: DarkModeColors.darkInversePrimary,
        shadow: DarkModeColors.darkShadow,
        surface: DarkModeColors.darkSurface,
        onSurface: DarkModeColors.darkOnSurface,
      ),
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        backgroundColor: DarkModeColors.darkAppBarBackground,
        foregroundColor: DarkModeColors.darkOnPrimaryContainer,
        elevation: 0,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ),
    );
