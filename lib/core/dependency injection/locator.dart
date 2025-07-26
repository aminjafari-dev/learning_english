// locator.dart
// Registers all dependencies for the authentication feature and core.

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_english/core/dependency%20injection/sign_in_di.dart';
import 'package:learning_english/core/dependency%20injection/level_selection_di.dart';
import 'package:learning_english/core/dependency%20injection/daily_lessons_di.dart';
import 'package:learning_english/core/dependency%20injection/learning_focus_selection_di.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies for the application
/// This function should be called before the app starts
Future<void> initDependencies() async {
  // Register SharedPreferences as a singleton
  // This is used by local data sources for persistent storage
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Sign in Dependencies
  signInDi(getIt);
  // Level Selection Feature
  setupLevelSelectionDI(getIt);

  // Daily Lessons Feature
  setupDailyLessonsDI(getIt);

  // Learning Focus Selection Feature
  setupLearningFocusSelectionDI(getIt);
}
