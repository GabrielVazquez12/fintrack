import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
    static const primary = Color(0xFF1B3A2F);
    static const background = Color(0xFFF7F3EC);
    static const surface = Color(0xFFFFFFFF);
    static const gold = Color(0xFFC9A15A); // income / accent
    static const terracotta = Color(0xFFB5533C); // expenses
    static const ink = Color(0xFF3A3A38); // primary text
    static const inkFaint = Color(0xFF8A8680); // secondary text
    static const divider = Color(0xFFE1DACB);
}

class AppTheme {
    static TextTheme get _textTheme {
        final base = GoogleFonts.interTextTheme();
        return base.copyWith(
        // Serif display face for large monetary figures, used with restraint.
        displayLarge: GoogleFonts.ptSerif(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
            letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.ptSerif(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
        ),
        titleLarge: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
        ),
        bodyLarge: GoogleFonts.inter(fontSize: 15, color: AppColors.ink),
        bodyMedium: GoogleFonts.inter(fontSize: 13, color: AppColors.inkFaint),
        labelSmall: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.inkFaint,
            letterSpacing: 0.6,
        ),
        );
    }

    static ThemeData get theme {
        return ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            surface: AppColors.surface,
            background: AppColors.background,
        ),
        textTheme: _textTheme,
        appBarTheme: AppBarTheme(
            backgroundColor: AppColors.background,
            elevation: 0,
            foregroundColor: AppColors.ink,
            titleTextStyle: _textTheme.titleLarge,
            centerTitle: false,
        ),
        cardTheme: CardThemeData(
            color: AppColors.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.divider),
            ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
            ),
            ),
        ),
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
        ),
        dividerColor: AppColors.divider,
        );
    }
}