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
import 'package:learning_english/core/theme/app_colors.dart';

/// This class defines the app's theme configuration using the centralized color palette.
class AppTheme {
  /// Gold color for highlights and buttons
  static Color get gold => AppColors.gold;

  /// Main background color
  static Color get background => AppColors.background;

  /// Surface/card color
  static Color get surface => AppColors.surface;

  /// Hint/secondary text color
  static Color get hint => AppColors.hint;

  /// Error color
  static Color get error => AppColors.error;

  /// Text color
  static Color get text => AppColors.text;

  /// Accent color
  static Color get accent => AppColors.accent;

  /// Secondary color
  static Color get secondary => AppColors.secondary;

  /// Secondary background color
  static Color get secondaryBackground => AppColors.secondaryBackground;

  /// Dark theme for the app using the defined color palette.
  static ThemeData get darkTheme => ThemeData(
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.background, // Text/icons on primary
      secondary: AppColors.accent,
      onSecondary: AppColors.background, // Text/icons on secondary
      background: AppColors.background,
      onBackground: AppColors.text, // Text/icons on background
      surface: AppColors.surface,
      onSurface: AppColors.text, // Text/icons on surface
      error: AppColors.error,
      onError: AppColors.background, // Text/icons on error
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 18,
        color: AppColors.white,
        fontWeight: FontWeight.w600,
        fontFamily: FontConstants.persianFont,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: AppColors.white,
        fontFamily: FontConstants.persianFont,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: AppColors.accent,
        fontFamily: FontConstants.persianFont,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontFamily: FontConstants.persianFont,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        color: AppColors.accent,
        fontWeight: FontWeight.w500,
        fontFamily: FontConstants.persianFont,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        color: AppColors.accent,
        fontFamily: FontConstants.persianFont,
      ),
    ),
    cardColor: AppColors.surface,
    dividerColor: AppColors.secondary,
    iconTheme: IconThemeData(color: AppColors.accent),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.secondaryBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.secondary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.secondary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      hintStyle: TextStyle(
        color: AppColors.accent,
        fontFamily: FontConstants.persianFont,
      ),
      labelStyle: TextStyle(
        color: AppColors.accent,
        fontFamily: FontConstants.persianFont,
      ),
    ),
  );
}
