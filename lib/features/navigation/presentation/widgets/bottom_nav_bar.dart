/// BottomNavBar provides easy navigation between main app pages.
///
/// This widget creates a bottom navigation bar with two main options:
/// - Level Selection: For choosing English learning level
/// - Profile: For accessing user profile settings
///
/// Usage Example:
///   BottomNavBar(
///     currentIndex: 0,
///     onTap: (index) => Navigator.pushNamed(context, routes[index]),
///   )
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/router/page_name.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/widgets/g_text.dart';

/// Bottom navigation bar widget for main app navigation
class BottomNavBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when a tab is tapped
  final Function(int) onTap;

  /// Constructor for BottomNavBar
  ///
  /// Parameters:
  ///   - currentIndex: The currently selected tab index (0 for level, 1 for profile)
  ///   - onTap: Callback function when a tab is tapped
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(top: BorderSide(color: AppTheme.oliveColor, width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context,
                icon: Icons.school,
                label: l10n.levelSelection,
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _buildNavItem(
                context,
                icon: Icons.history,
                label: l10n.history,
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _buildNavItem(
                context,
                icon: Icons.person,
                label: l10n.profileTitle,
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a single navigation item
  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.oliveColor,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color:
                  isSelected ? AppTheme.backgroundColor : AppTheme.accentColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            GText(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.backgroundColor : AppTheme.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extension to provide easy navigation methods
extension BottomNavBarNavigation on BuildContext {
  /// Navigate to level selection page
  void navigateToLevelSelection() {
    Navigator.of(this).pushNamed(PageName.levelSelection);
  }

  /// Navigate to vocabulary history page
  void navigateToVocabularyHistory() {
    Navigator.of(this).pushNamed(PageName.vocabularyHistory);
  }

  /// Navigate to profile page
  void navigateToProfile() {
    Navigator.of(this).pushNamed(PageName.profile);
  }
}
