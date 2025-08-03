 import 'package:flutter/material.dart';

/// AppColors centralizes all color definitions used throughout the app.
/// Based on the design system color palette.
class AppColors {
  // Primary Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color gold = Color(0xFFD1A317);
  
  // Background Colors
  static const Color darkBrown = Color(0xFF211F12);
  static const Color mediumBrown = Color(0xFF332B1A);
  static const Color darkOlive = Color(0xFF473D24);
  
  // Accent Colors
  static const Color lightBeige = Color(0xFFC7BA94);
  static const Color olive = Color(0xFF665933);
  
  // Theme-specific colors
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkSecondaryBackground = Color(0xFF3A3A3A);
  static const Color yellowButton = Color(0xFFFFD700);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkSecondaryText = Color(0xFFB0B0B0);
  
  // Semantic colors
  static const Color error = Color(0xFFD1A317); // Using gold for warnings/errors
  
  // Getters for semantic naming
  static Color get primary => gold;
  static Color get background => darkBrown;
  static Color get surface => mediumBrown;
  static Color get secondaryBackground => darkOlive;
  static Color get accent => lightBeige;
  static Color get secondary => olive;
  static Color get text => white;
  static Color get hint => lightBeige;
}