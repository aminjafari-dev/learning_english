import 'package:flutter/material.dart';
import 'package:learning_english/core/constants/font_constants.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/theme/cubit/theme_cubit.dart';

/// Theme data class that contains all colors for a theme
class ThemeDataColors {
  final Color primary;
  final Color background;
  final Color surface;
  final Color accent;
  final Color secondary;
  final Color text;
  final Color hint;
  final Color error;
  final Color secondaryBackground;

  const ThemeDataColors({
    required this.primary,
    required this.background,
    required this.surface,
    required this.accent,
    required this.secondary,
    required this.text,
    required this.hint,
    required this.error,
    required this.secondaryBackground,
  });
}

/// App themes configuration
class AppThemes {
  // Gold theme colors
  static const ThemeDataColors goldTheme = ThemeDataColors(
    primary: Color(0xFFD1A317), // Gold
    background: Color(0xFF211F12), // Dark Brown
    surface: Color(0xFF332B1A), // Medium Brown
    accent: Color(0xFFC7BA94), // Light Beige
    secondary: Color(0xFF665933), // Olive
    text: Color(0xFFFFFFFF), // White
    hint: Color(0xFFC7BA94), // Light Beige
    error: Color(0xFFD1A317), // Gold
    secondaryBackground: Color(0xFF473D24), // Dark Olive
  );

  // Blue theme colors
  static const ThemeDataColors blueTheme = ThemeDataColors(
    primary: Color(0xFF0D80F2), // Vibrant Blue
    background: Color(0xFF0F1A24), // Very Dark Blue
    surface: Color(0xFF172633), // Dark Teal
    accent: Color(0xFF8FADCC), // Light Grayish Blue
    secondary: Color(0xFF304D69), // Muted Medium Blue
    text: Color(0xFFFFFFFF), // White
    hint: Color(0xFF8FADCC), // Light Grayish Blue
    error: Color(0xFF0D80F2), // Vibrant Blue
    secondaryBackground: Color(0xFF21364A), // Dark Greenish Blue
  );

  // Light theme colors
  static const ThemeDataColors lightTheme = ThemeDataColors(
    primary: Color(0xFFD1A317), // Golden yellow/mustard
    background: Color(0xFFFFFFFF), // Pure white
    surface: Color(0xFFF5F2F0), // Very light cream
    accent: Color(0xFF878063), // Muted olive green
    secondary: Color(0xFFE5E3DB), // Light beige
    text: Color(0xFF171712), // Very dark brown/off-black
    hint: Color(0xFF878063), // Muted olive green
    error: Color(0xFFD1A317), // Golden yellow
    secondaryBackground: Color(0xFFF5F2F0), // Very light cream
  );

  // Light blue theme colors
  static const ThemeDataColors lightBlueTheme = ThemeDataColors(
    primary: Color(0xFF0D80F2), // Bright, vibrant blue
    background: Color(0xFFFFFFFF), // Pure white
    surface: Color(
      0xFFF7FAFC,
    ), // Very light, cool off-white with blue/gray tint
    accent: Color(0xFF4A739C), // Medium, muted blue with grayish undertone
    secondary: Color(0xFFCFDBE8), // Very light, desaturated blue-gray
    text: Color(0xFF0D141C), // Very dark, desaturated blue (almost black)
    hint: Color(0xFF4A739C), // Medium, muted blue with grayish undertone
    error: Color(0xFF0D80F2), // Bright, vibrant blue
    secondaryBackground: Color(
      0xFFE8EDF5,
    ), // Very light, cool off-white with purplish-gray tint
  );

  /// Get theme colors based on theme type
  static ThemeDataColors getThemeColors(ThemeType themeType) {
    switch (themeType) {
      case ThemeType.gold:
        return goldTheme;
      case ThemeType.blue:
        return blueTheme;
      case ThemeType.light:
        return lightTheme;
      case ThemeType.lightBlue:
        return lightBlueTheme;
    }
  }

  /// Get current theme colors from context
  static ThemeDataColors getCurrentThemeColors(BuildContext context) {
    final themeCubit = getIt<ThemeCubit>();
    return getThemeColors(themeCubit.currentTheme);
  }

  /// Create MaterialApp theme data
  static ThemeData createThemeData(ThemeType themeType) {
    final colors = getThemeColors(themeType);

    return ThemeData(
      primaryColor: colors.primary,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: colors.primary,
        onPrimary: colors.background,
        secondary: colors.accent,
        onSecondary: colors.background,
        background: colors.background,
        onBackground: colors.text,
        surface: colors.surface,
        onSurface: colors.text,
        error: colors.error,
        onError: colors.background,
      ),
      scaffoldBackgroundColor: colors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.text,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.background,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: 18,
          color: colors.text,
          fontWeight: FontWeight.w600,
          fontFamily: FontConstants.persianFont,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: colors.text,
          fontFamily: FontConstants.persianFont,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          color: colors.accent,
          fontFamily: FontConstants.persianFont,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          color: colors.text,
          fontWeight: FontWeight.bold,
          fontFamily: FontConstants.persianFont,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          color: colors.accent,
          fontWeight: FontWeight.w500,
          fontFamily: FontConstants.persianFont,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          color: colors.accent,
          fontFamily: FontConstants.persianFont,
        ),
      ),
      cardColor: colors.surface,
      dividerColor: colors.secondary,
      iconTheme: IconThemeData(color: colors.accent),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.secondaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.secondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.secondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        hintStyle: TextStyle(
          color: colors.accent,
          fontFamily: FontConstants.persianFont,
        ),
        labelStyle: TextStyle(
          color: colors.accent,
          fontFamily: FontConstants.persianFont,
        ),
      ),
    );
  }
}
