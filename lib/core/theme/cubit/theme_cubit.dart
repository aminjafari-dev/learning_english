import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme types available in the app
enum ThemeType {
  gold, // Original gold theme
  blue, // New blue theme
}

/// Theme state class
class ThemeState extends Equatable {
  final ThemeType themeType;

  const ThemeState({required this.themeType});

  @override
  List<Object?> get props => [themeType];

  /// Create initial state with gold theme
  factory ThemeState.initial() => const ThemeState(themeType: ThemeType.gold);
}

/// Theme cubit for managing theme changes
class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'selected_theme';
  final SharedPreferences _prefs;

  ThemeCubit({required SharedPreferences prefs})
    : _prefs = prefs,
      super(ThemeState.initial()) {
    _loadSavedTheme();
  }

  /// Load the saved theme from local storage
  Future<void> _loadSavedTheme() async {
    try {
      final savedThemeString = _prefs.getString(_themeKey);
      if (savedThemeString != null) {
        final savedTheme = _parseThemeType(savedThemeString);
        if (savedTheme != null) {
          emit(ThemeState(themeType: savedTheme));
        }
      }
    } catch (e) {
      // If there's an error loading the theme, keep the default (gold)
      // Error is silently handled to maintain app stability
    }
  }

  /// Save theme to local storage
  Future<void> _saveTheme(ThemeType themeType) async {
    try {
      await _prefs.setString(_themeKey, themeType.name);
    } catch (e) {
      // Error is silently handled to maintain app stability
    }
  }

  /// Parse theme type from string
  ThemeType? _parseThemeType(String themeString) {
    switch (themeString) {
      case 'gold':
        return ThemeType.gold;
      case 'blue':
        return ThemeType.blue;
      default:
        return null;
    }
  }

  /// Switch to a different theme and save it
  Future<void> switchTheme(ThemeType themeType) async {
    emit(ThemeState(themeType: themeType));
    await _saveTheme(themeType);
  }

  /// Toggle between gold and blue themes and save the selection
  Future<void> toggleTheme() async {
    final newTheme =
        state.themeType == ThemeType.gold ? ThemeType.blue : ThemeType.gold;
    await switchTheme(newTheme);
  }

  /// Get current theme type
  ThemeType get currentTheme => state.themeType;
}
