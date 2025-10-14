import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color iceWhite = Color(0xFFF8F9FA);
  static const Color leadGray = Color(0xFF6C757D);
  static const Color matteBlack = Color(0xFF212529);
  static const Color metallicBlue = Color(0xFF007BFF);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: metallicBlue,
      brightness: Brightness.light,
      primary: metallicBlue,
      secondary: leadGray,
      surface: iceWhite,
      onSurface: matteBlack,
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: matteBlack,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: matteBlack,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: leadGray,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: metallicBlue,
        foregroundColor: iceWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 4,
        shadowColor: metallicBlue.withOpacity(0.3),
      ),
    ),
    cardTheme: CardThemeData(
      color: iceWhite.withOpacity(0.8),
      shadowColor: leadGray.withOpacity(0.2),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: iceWhite.withOpacity(0.9),
      selectedItemColor: metallicBlue,
      unselectedItemColor: leadGray,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: metallicBlue,
      brightness: Brightness.dark,
      primary: metallicBlue,
      secondary: leadGray,
      surface: matteBlack,
      onSurface: iceWhite,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: iceWhite,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: iceWhite,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: leadGray,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: metallicBlue,
        foregroundColor: iceWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 4,
        shadowColor: metallicBlue.withOpacity(0.3),
      ),
    ),
    cardTheme: CardThemeData(
      color: matteBlack.withOpacity(0.8),
      shadowColor: leadGray.withOpacity(0.2),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: matteBlack.withOpacity(0.9),
      selectedItemColor: metallicBlue,
      unselectedItemColor: leadGray,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),
  );
}
