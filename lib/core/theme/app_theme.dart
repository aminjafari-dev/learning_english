/// AppTheme provides easy access to theme colors from context.
///
/// Usage Example:
///   AppTheme.primary(context) // Gets current theme's primary color
///   AppTheme.background(context) // Gets current theme's background color
///
/// This works with the theme cubit system for dynamic theme switching.
import 'package:flutter/material.dart';
import 'package:learning_english/core/theme/app_themes.dart';

/// AppTheme provides easy access to current theme colors
class AppTheme {
  /// Get primary color from current theme
  static Color primary(BuildContext context) =>
      AppThemes.getCurrentThemeColors(context).primary;

  /// Get background color from current theme
  static Color background(BuildContext context) =>
      AppThemes.getCurrentThemeColors(context).background;

  /// Get surface color from current theme
  static Color surface(BuildContext context) =>
      AppThemes.getCurrentThemeColors(context).surface;

  /// Get accent color from current theme
  static Color accent(BuildContext context) =>
      AppThemes.getCurrentThemeColors(context).accent;

  /// Get secondary color from current theme
  static Color secondary(BuildContext context) =>
      AppThemes.getCurrentThemeColors(context).secondary;

  /// Get text color from current theme
  static Color text(BuildContext context) =>
      AppThemes.getCurrentThemeColors(context).text;

  /// Get hint color from current theme
  static Color hint(BuildContext context) =>
      AppThemes.getCurrentThemeColors(context).hint;

  /// Get error color from current theme
  static Color error(BuildContext context) =>
      AppThemes.getCurrentThemeColors(context).error;

  /// Get secondary background color from current theme
  static Color secondaryBackground(BuildContext context) =>
      AppThemes.getCurrentThemeColors(context).secondaryBackground;
}
