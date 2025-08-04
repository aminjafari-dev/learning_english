import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/theme/cubit/theme_cubit.dart';
import 'package:learning_english/core/widgets/global_widget/g_scaffold.dart';
import 'package:learning_english/core/constants/font_constants.dart';
import 'package:learning_english/features/level_selection/presentation/pages/level_selection_page.dart';
import 'package:learning_english/features/profile/presentation/pages/profile_page.dart';
import 'package:learning_english/features/history/presentation/pages/vocabulary_history_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ThemeCubit, ThemeState>(
      bloc: getIt<ThemeCubit>(),
      builder: (context, themeState) {
        return GScaffold(
          backgroundColor: AppTheme.background(context),
          body: IndexedStack(index: _currentIndex, children: _pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: AppTheme.primary(context),
            unselectedItemColor: AppTheme.accent(
              context,
            ).withValues(alpha: 0.7),
            selectedLabelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: FontConstants.persianFont,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12,
              fontFamily: FontConstants.persianFont,
            ),
            selectedIconTheme: IconThemeData(
              color: AppTheme.primary(context),
              size: 24,
            ),
            unselectedIconTheme: IconThemeData(
              color: AppTheme.accent(context),
              size: 18,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: l10n.levelSelection,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: l10n.history,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: l10n.profileTitle,
              ),
            ],
          ),
        );
      },
    );
  }
}
