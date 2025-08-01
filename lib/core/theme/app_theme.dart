/// AppTheme centralizes the app's color scheme and text styles.
///
/// Usage Example:
///   MaterialApp(
///     theme: AppTheme.lightTheme,
///   )
///
/// This helps maintain a consistent look and feel across the app.
import 'package:flutter/material.dart';
import 'package:learning_english/core/constants/font_constants.dart';

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

  // Dark theme colors based on the UI design
  // Dark background color (from the UI screens)
  static const Color darkBackgroundColor = Color(0xFF1A1A1A); // Very dark gray
  // Dark surface/card color
  static const Color darkSurfaceColor = Color(0xFF2D2D2D); // Dark gray
  // Dark secondary background
  static const Color darkSecondaryBackground = Color(
    0xFF3A3A3A,
  ); // Medium dark gray
  // Yellow button color (from the UI)
  static const Color yellowButtonColor = Color(0xFFFFD700); // Bright yellow
  // Dark text color
  static const Color darkTextColor = Color(0xFFFFFFFF); // White text
  // Secondary text color for dark theme
  static const Color darkSecondaryTextColor = Color(0xFFB0B0B0); // Light gray

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
        fontFamily: FontConstants.persianFont,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: white,
        fontFamily: FontConstants.persianFont,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: accentColor,
        fontFamily: FontConstants.persianFont,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        color: white,
        fontWeight: FontWeight.bold,
        fontFamily: FontConstants.persianFont,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        color: accentColor,
        fontWeight: FontWeight.w500,
        fontFamily: FontConstants.persianFont,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        color: accentColor,
        fontFamily: FontConstants.persianFont,
      ),
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
      hintStyle: const TextStyle(
        color: Color(0xFFC7BA94),
        fontFamily: FontConstants.persianFont,
      ),
      labelStyle: const TextStyle(
        color: Color(0xFFC7BA94),
        fontFamily: FontConstants.persianFont,
      ),
    ),
  );

  /// Dark theme for the app based on the UI design.
  /// This theme matches the dark interface shown in the design screens.
  static ThemeData get darkTheme => ThemeData(
    primaryColor: yellowButtonColor,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: yellowButtonColor,
      onPrimary: darkBackgroundColor, // Text/icons on primary
      secondary: darkSecondaryTextColor,
      onSecondary: darkBackgroundColor, // Text/icons on secondary
      background: darkBackgroundColor,
      onBackground: darkTextColor, // Text/icons on background
      surface: darkSurfaceColor,
      onSurface: darkTextColor, // Text/icons on surface
      error: yellowButtonColor,
      onError: darkBackgroundColor, // Text/icons on error
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurfaceColor,
      foregroundColor: darkTextColor,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: yellowButtonColor,
        foregroundColor: darkBackgroundColor,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        minimumSize: const Size(double.infinity, 50),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 18,
        color: darkTextColor,
        fontWeight: FontWeight.w600,
        fontFamily: FontConstants.persianFont,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: darkTextColor,
        fontFamily: FontConstants.persianFont,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: darkSecondaryTextColor,
        fontFamily: FontConstants.persianFont,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        color: darkTextColor,
        fontWeight: FontWeight.bold,
        fontFamily: FontConstants.persianFont,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        color: darkTextColor,
        fontWeight: FontWeight.w500,
        fontFamily: FontConstants.persianFont,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        color: darkSecondaryTextColor,
        fontFamily: FontConstants.persianFont,
      ),
    ),
    cardColor: darkSurfaceColor,
    dividerColor: darkSecondaryBackground,
    iconTheme: const IconThemeData(color: darkSecondaryTextColor),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSecondaryBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: darkSecondaryBackground),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: darkSecondaryBackground),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: yellowButtonColor, width: 2),
      ),
      hintStyle: const TextStyle(
        color: darkSecondaryTextColor,
        fontFamily: FontConstants.persianFont,
      ),
      labelStyle: const TextStyle(
        color: darkSecondaryTextColor,
        fontFamily: FontConstants.persianFont,
      ),
    ),
  );
}
