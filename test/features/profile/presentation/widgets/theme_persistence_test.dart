import 'package:flutter_test/flutter_test.dart';
import 'package:learning_english/core/theme/cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemeCubit Persistence', () {
    late ThemeCubit themeCubit;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    tearDown(() {
      themeCubit.close();
    });

    test('should save and load gold theme', () async {
      themeCubit = ThemeCubit(prefs: prefs);

      // Initially should be gold theme
      expect(themeCubit.currentTheme, equals(ThemeType.gold));

      // Switch to blue theme
      await themeCubit.switchTheme(ThemeType.blue);
      expect(themeCubit.currentTheme, equals(ThemeType.blue));

      // Verify it was saved
      final savedTheme = prefs.getString('selected_theme');
      expect(savedTheme, equals('blue'));
    });

    test('should load saved theme on initialization', () async {
      // First, save a blue theme
      await prefs.setString('selected_theme', 'blue');

      // Create new cubit - should load the saved theme
      themeCubit = ThemeCubit(prefs: prefs);

      // Should load the saved blue theme
      expect(themeCubit.currentTheme, equals(ThemeType.blue));
    });

    test('should handle invalid saved theme gracefully', () async {
      // Save an invalid theme
      await prefs.setString('selected_theme', 'invalid_theme');

      // Create new cubit - should fall back to default
      themeCubit = ThemeCubit(prefs: prefs);

      // Should fall back to gold theme
      expect(themeCubit.currentTheme, equals(ThemeType.gold));
    });

    test('should toggle theme correctly', () async {
      themeCubit = ThemeCubit(prefs: prefs);

      // Initially gold
      expect(themeCubit.currentTheme, equals(ThemeType.gold));

      // Toggle to blue
      await themeCubit.toggleTheme();
      expect(themeCubit.currentTheme, equals(ThemeType.blue));

      // Toggle back to gold
      await themeCubit.toggleTheme();
      expect(themeCubit.currentTheme, equals(ThemeType.gold));
    });
  });
}
