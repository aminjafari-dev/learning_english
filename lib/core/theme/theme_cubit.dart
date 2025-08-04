import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

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
  ThemeCubit() : super(ThemeState.initial());

  /// Switch to a different theme
  void switchTheme(ThemeType themeType) {
    emit(ThemeState(themeType: themeType));
  }

  /// Toggle between gold and blue themes
  void toggleTheme() {
    final newTheme =
        state.themeType == ThemeType.gold ? ThemeType.blue : ThemeType.gold;
    switchTheme(newTheme);
  }

  /// Get current theme type
  ThemeType get currentTheme => state.themeType;
}
