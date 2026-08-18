import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Distressed dark-mode theme for Flop Fantasy.
///
/// Palette is muted, slightly desaturated, with a "burnt" accent for disaster
/// highlights. Fonts use a typewriter / stencil pairing for the distressed feel.
class AppTheme {
  AppTheme._();

  // Brand palette
  static const Color bgBase = Color(0xFF0E0B08); // near-black, warm undertone
  static const Color bgPanel = Color(0xFF1A1410);
  static const Color bgRaised = Color(0xFF231B14);
  static const Color border = Color(0xFF3A2D22);
  static const Color textPrimary = Color(0xFFE9DCC9);
  static const Color textMuted = Color(0xFF8A7B68);

  static const Color accentBlood = Color(0xFFB23A2A); // red card / catastrophe
  static const Color accentRust = Color(0xFFC07A2C); // own goal / ironic glory
  static const Color accentMustard = Color(0xFFD9B25A); // yellow card / mild flop
  static const Color accentBruise = Color(0xFF6B4A66); // injury / haunted

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.specialEliteTextTheme(base.textTheme).copyWith(
      headlineLarge: GoogleFonts.specialElite(
        textStyle: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: textPrimary,
        ),
      ),
      headlineMedium: GoogleFonts.specialElite(
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: textPrimary,
        ),
      ),
      titleLarge: GoogleFonts.specialElite(
        textStyle: const TextStyle(
          fontSize: 18,
          color: textPrimary,
          letterSpacing: 0.8,
        ),
      ),
      bodyLarge: GoogleFonts.jetBrainsMono(
        textStyle: const TextStyle(fontSize: 14, color: textPrimary),
      ),
      bodyMedium: GoogleFonts.jetBrainsMono(
        textStyle: const TextStyle(fontSize: 13, color: textPrimary),
      ),
      bodySmall: GoogleFonts.jetBrainsMono(
        textStyle: const TextStyle(fontSize: 12, color: textMuted),
      ),
      labelLarge: GoogleFonts.specialElite(
        textStyle: const TextStyle(fontSize: 14, color: textPrimary, letterSpacing: 1.0),
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: bgBase,
      canvasColor: bgBase,
      colorScheme: const ColorScheme.dark(
        surface: bgPanel,
        primary: accentBlood,
        secondary: accentRust,
        tertiary: accentMustard,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        error: accentBlood,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: bgBase,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineMedium,
      ),
      cardTheme: const CardThemeData(
        color: bgPanel,
        elevation: 0,
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          side: BorderSide(color: border),
        ),
      ),
      dividerTheme: const DividerThemeData(color: border, thickness: 1),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bgPanel,
        selectedItemColor: accentRust,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentBlood,
          foregroundColor: textPrimary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          side: const BorderSide(color: border),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgRaised,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: border),
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: border),
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: accentMustard),
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        hintStyle: TextStyle(color: textMuted),
      ),
      iconTheme: const IconThemeData(color: textPrimary),
    );
  }
}

/// Maps disaster categories to accent colours for consistent use across UI.
class DisasterPalette {
  static Color forPoints(int points) {
    if (points >= 8) return AppTheme.accentBlood;
    if (points >= 4) return AppTheme.accentRust;
    if (points >= 2) return AppTheme.accentMustard;
    return AppTheme.accentBruise;
  }
}
