/// MainNavigationPage demonstrates the usage of BottomNavBar widget.
///
/// This page shows how to implement a simple navigation system with
/// a bottom navigation bar that allows users to switch between
/// level selection and profile pages.
///
/// Usage Example:
///   Navigator.of(context).pushNamed(PageName.mainNavigation);
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/router/page_name.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/g_scaffold.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/features/level_selection/presentation/pages/level_selection_page.dart';
import 'package:learning_english/features/profile/presentation/pages/profile_page.dart';
import 'package:learning_english/features/vocabulary_history/presentation/pages/vocabulary_history_page.dart';
import 'package:learning_english/features/navigation/presentation/widgets/bottom_nav_bar.dart';

/// Main navigation page with bottom navigation bar
class MainNavigationPage extends StatefulWidget {
  /// Constructor for MainNavigationPage
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  /// Current selected tab index
  int _currentIndex = 0;

  /// List of pages to display
  final List<Widget> _pages = [
    const LevelSelectionPage(),
    const VocabularyHistoryPage(),
    const ProfilePage(),
  ];


  @override
  Widget build(BuildContext context) {
    return GScaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
