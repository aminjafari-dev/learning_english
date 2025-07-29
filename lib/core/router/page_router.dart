// page_router.dart
// This file registers all named routes for the app using the PageName constants.
// Add each new page to the routes map below.
// Example usage: Navigator.of(context).pushNamed(PageName.authentication);

import 'package:flutter/material.dart';
import 'package:learning_english/core/router/page_name.dart';
import 'package:learning_english/features/splash/presentation/pages/splash_page.dart';
import 'package:learning_english/features/authentication/presentation/pages/authentication_page.dart';
import 'package:learning_english/features/level_selection/presentation/pages/level_selection_page.dart';
import 'package:learning_english/features/learning_focus_selection/presentation/pages/learning_focus_selection_page.dart';
import 'package:learning_english/features/daily_lessons/presentation/pages/daily_lessons_page.dart';
import 'package:learning_english/features/profile/presentation/pages/profile_page.dart';
import 'package:learning_english/features/navigation/presentation/pages/main_navigation_page.dart';
import 'package:learning_english/features/history/presentation/pages/vocabulary_history_page.dart';
import 'package:learning_english/features/history/presentation/pages/request_detail_page.dart';

class PageRouter {
  /// Map of all named routes in the app
  static Map<String, WidgetBuilder> routes = {
    PageName.splash: (context) => const SplashPage(),
    PageName.authentication: (context) => const AuthenticationPage(),
    PageName.levelSelection: (context) => const LevelSelectionPage(),
    PageName.learningFocusSelection:
        (context) => const LearningFocusSelectionPage(),
    // Daily Lessons page
    PageName.dailyLessons: (context) => const DailyLessonsPage(),
    // Profile page
    PageName.profile: (context) => const ProfilePage(),
    // Main navigation page
    PageName.mainNavigation: (context) => const MainNavigationPage(),
    // Vocabulary history page
    PageName.vocabularyHistory: (context) => const VocabularyHistoryPage(),
    // Request details page
    PageName.requestDetails: (context) {
      final requestId = ModalRoute.of(context)!.settings.arguments as String;
      return RequestDetailPage(requestId: requestId);
    },
  };
}
