// locator.dart
// Registers all dependencies for the authentication feature and core.

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_english/core/dependency%20injection/core_di.dart';
import 'package:learning_english/core/dependency%20injection/sign_in_di.dart';
import 'package:learning_english/core/dependency%20injection/level_selection_di.dart';
import 'package:learning_english/core/dependency%20injection/daily_lessons_di.dart';
import 'package:learning_english/core/dependency%20injection/learning_focus_selection_di.dart';
import 'package:learning_english/core/dependency%20injection/splash_di.dart';
import 'package:learning_english/core/dependency%20injection/profile_di.dart';
import 'package:learning_english/core/dependency%20injection/vocabulary_history_di.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies for the application
/// This function should be called before the app starts
Future<void> initDependencies() async {
  try {
    // Initialize Hive for local storage
    await Hive.initFlutter();

    // Register SharedPreferences as a singleton
    // This is used by local data sources for persistent storage
    final prefs = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(prefs);

    // Core Dependencies (must be first as other features depend on them)
    setupCoreDI(getIt);

    // Splash Feature
    await setupSplashLocator(getIt);

    // Sign in Dependencies
    signInDi(getIt);

    // Level Selection Feature
    setupLevelSelectionDI(getIt);

    // Learning Focus Selection Feature (must be before daily lessons)
    setupLearningFocusSelectionDI(getIt);

    // Daily Lessons Feature (now async due to Hive initialization)
    // This depends on LearningFocusSelectionRepository, so it must come after
    await setupDailyLessonsDI(getIt);

    // Profile Feature
    await setupProfileDI(getIt);

    // Vocabulary History Feature
    await setupVocabularyHistoryLocator(getIt);

    print('✅ [DI] All dependencies initialized successfully');
  } catch (e) {
    print('❌ [DI] Error initializing dependencies: $e');
    rethrow; // Re-throw to let the caller handle the error
  }
}
