// locator.dart
// Registers all dependencies for the authentication feature and core.

import 'package:get_it/get_it.dart';
import 'package:learning_english/core/dependency%20injection/sign_in_di.dart';
import 'package:learning_english/core/dependency%20injection/level_selection_di.dart';
import 'package:learning_english/core/dependency%20injection/daily_lessons_di.dart';
import 'package:learning_english/core/dependency%20injection/learning_focus_selection_di.dart';

final getIt = GetIt.instance;

void initDependencies() {
  // Sign in Dependencies
  signInDi(getIt);
  // Level Selection Feature
  setupLevelSelectionDI(getIt);

  // Daily Lessons Feature
  setupDailyLessonsDI(getIt);

  // Learning Focus Selection Feature
  setupLearningFocusSelectionDI(getIt);
}
