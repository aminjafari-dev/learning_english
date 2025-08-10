// user_preferences_display.dart
// Widget to display user preferences (level and focus areas) in the daily lessons page.
// This widget shows the user's selected level and learning focus areas in a beautiful design.
// Usage: Place this widget above the vocabulary section to show user's learning context.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import '../bloc/daily_lessons_bloc.dart';
import '../bloc/daily_lessons_state.dart';
import '../bloc/daily_lessons_event.dart';
import '../../domain/entities/user_preferences.dart';
import '../../data/models/level_type.dart';
import 'package:learning_english/l10n/app_localizations.dart';

/// Widget to display user preferences in the daily lessons page
/// Shows the user's selected level and learning focus areas
/// Designed to be placed above the vocabulary section
class UserPreferencesDisplay extends StatelessWidget {
  const UserPreferencesDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyLessonsBloc, DailyLessonsState>(
      bloc: getIt<DailyLessonsBloc>(),
      builder: (context, state) {
        if (state.userPreferences is UserPreferencesLoaded) {
          final preferences =
              (state.userPreferences as UserPreferencesLoaded).preferences;
          return _buildPreferencesCard(context, preferences);
        } else if (state.userPreferences is UserPreferencesLoading) {
          return _buildLoadingCard(context);
        } else if (state.userPreferences is UserPreferencesError) {
          return _buildErrorCard(
            context,
            (state.userPreferences as UserPreferencesError).message,
          );
        }

        // Don't show anything if preferences are not loaded yet
        return const SizedBox.shrink();
      },
    );
  }

  /// Builds the main preferences display card
  Widget _buildPreferencesCard(
    BuildContext context,
    UserPreferences preferences,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary(context).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primary(context).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Level and Focus Areas Row
          Row(
            children: [
              // Level Badge
              _buildPreferenceInfo(
                context,
                title: AppLocalizations.of(context)!.levelSelection,
                value: _getLevelDisplayText(preferences.level, context),
              ),
              GGap.g12,
              _buildPreferenceInfo(
                context,
                title: AppLocalizations.of(context)!.focusAreasSelection,
                value: preferences.focusAreas.join(', '),
              ),

              // Focus Areas
            ],
          ),
          // Debug button for testing conversation mode
          if (const bool.fromEnvironment('DEBUG_MODE', defaultValue: false))
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ElevatedButton(
                onPressed: () {
                  // Test conversation mode
                  final bloc = context.read<DailyLessonsBloc>();
                  bloc.add(const DailyLessonsEvent.fetchLessons());
                },
                child: const Text('Test Conversation Mode'),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds loading state card
  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary(context).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primary(context).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.primary(context),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GText(
            'Loading your preferences...',
            style: TextStyle(
              color: AppTheme.primary(context),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds error state card
  Widget _buildErrorCard(BuildContext context, String errorMessage) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.error(context).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.error(context).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppTheme.error(context), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: GText(
              'Could not load preferences',
              style: TextStyle(
                color: AppTheme.error(context),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Gets display text for user level
  String _getLevelDisplayText(UserLevel level, BuildContext context) {
    switch (level) {
      case UserLevel.beginner:
        return AppLocalizations.of(context)!.levelBeginner;
      case UserLevel.elementary:
        return AppLocalizations.of(context)!.levelElementary;
      case UserLevel.intermediate:
        return AppLocalizations.of(context)!.levelIntermediate;
      case UserLevel.advanced:
        return AppLocalizations.of(context)!.levelAdvanced;
    }
  }

  Widget _buildPreferenceInfo(
    BuildContext context, {
    required String? title,
    required String value,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GText(
            "$title:",
            style: TextStyle(
              color: AppTheme.primary(context).withValues(alpha: 0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          GText(
            value,
            style: TextStyle(
              color: AppTheme.primary(context),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Example usage:
// UserPreferencesDisplay()
