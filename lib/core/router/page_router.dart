// page_router.dart
// This file registers all named routes for the app using the PageName constants.
// Add each new page to the routes map below.
// Example usage: Navigator.of(context).pushNamed(PageName.authentication);

import 'package:flutter/material.dart';
import 'package:learning_english/core/router/page_name.dart';
import 'package:learning_english/features/authentication/presentation/pages/authentication_page.dart';
import 'package:learning_english/features/level_selection/presentation/pages/level_selection_page.dart';

class PageRouter {
  /// Map of all named routes in the app
  static Map<String, WidgetBuilder> routes = {
    PageName.authentication: (context) => const AuthenticationPage(),
    PageName.levelSelection: (context) => const LevelSelectionPage(),
  };
}
