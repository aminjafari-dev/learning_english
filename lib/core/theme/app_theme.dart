/// AppTheme centralizes the app's color scheme and text styles.
///
/// Usage Example:
///   MaterialApp(
///     theme: AppTheme.lightTheme,
///   )
///
/// This helps maintain a consistent look and feel across the app.
import 'package:flutter/material.dart';

/// This class defines all the color constants used throughout the app.
/// Only use these colors in the UI. If you need a new color, add it here first.
class AppTheme {
  // Primary brand color (Gold)
  static const Color primaryColor = Color(0xFFD1A317); // Gold
  // Accent color (Light Beige)
  static const Color accentColor = Color(0xFFC7BA94); // Light Beige
  // Main background color (Dark Brown)
  static const Color backgroundColor = Color(0xFF211F12); // Dark Brown
  // Card/Surface color (Medium Brown)
  static const Color surfaceColor = Color(0xFF332B1A); // Medium Brown
  // Secondary background (Brown)
  static const Color secondaryBackground = Color(0xFF473D24); // Brown
  // Olive color for secondary elements
  static const Color oliveColor = Color(0xFF665933); // Olive
  // Error color (use Gold for warnings, or define a new one if needed)
  static const Color errorColor = Color(0xFFD1A317); // Gold as warning/error
  // White for text/icons on dark backgrounds
  static const Color white = Color(0xFFFFFFFF);

  /// Gold color for highlights and buttons
  static Color get gold => primaryColor;

  /// Main background color
  static Color get background => backgroundColor;

  /// Surface/card color
  static Color get surface => surfaceColor;

  /// Hint/secondary text color
  static Color get hint => accentColor;

  /// Light theme for the app using the defined color palette.
  static ThemeData get lightTheme => ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: backgroundColor, // Text/icons on primary
      secondary: accentColor,
      onSecondary: backgroundColor, // Text/icons on secondary
      background: backgroundColor,
      onBackground: white, // Text/icons on background
      surface: surfaceColor,
      onSurface: white, // Text/icons on surface
      error: errorColor,
      onError: backgroundColor, // Text/icons on error
    ),
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      foregroundColor: white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: backgroundColor,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 18,
        color: white,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: white),
      bodySmall: TextStyle(fontSize: 14, color: accentColor),
      titleLarge: TextStyle(
        fontSize: 22,
        color: white,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        color: accentColor,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(fontSize: 16, color: accentColor),
    ),
    cardColor: surfaceColor,
    dividerColor: oliveColor,
    iconTheme: const IconThemeData(color: accentColor),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: secondaryBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: oliveColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: oliveColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      hintStyle: const TextStyle(color: Color(0xFFC7BA94)),
      labelStyle: const TextStyle(color: Color(0xFFC7BA94)),
    ),
  );
}
