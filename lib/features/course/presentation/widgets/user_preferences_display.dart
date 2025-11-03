// learning_path_info_display.dart
// Widget to display learning path information (level and focus areas) in the courses page.
// This widget shows the user's learning path level and focus areas in a beautiful design.
// Usage: Place this widget above the vocabulary section to show user's learning context.
// Example: LearningPathInfoDisplay(learningPath: learningPath)

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/features/learning_paths/domain/entities/learning_path.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';
import 'package:learning_english/l10n/app_localizations.dart';

/// Widget to display learning path information in the courses page
/// Shows the learning path's level and focus areas
/// Designed to be placed above the vocabulary section
class LearningPathInfoDisplay extends StatelessWidget {
  /// The learning path to display information from
  /// If null, the widget will not be displayed
  final LearningPath? learningPath;

  const LearningPathInfoDisplay({super.key, this.learningPath});

  @override
  Widget build(BuildContext context) {
    // Don't show anything if learning path is not provided
    if (learningPath == null) {
      return const SizedBox.shrink();
    }

    return _buildInfoCard(context, learningPath!);
  }

  /// Builds the main learning path info display card
  /// Shows level and focus areas from the learning path
  Widget _buildInfoCard(BuildContext context, LearningPath learningPath) {
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
              _buildInfoItem(
                context,
                title: AppLocalizations.of(context)!.levelSelection,
                value: _getLevelDisplayText(learningPath.level, context),
              ),
              GGap.g12,
              _buildInfoItem(
                context,
                title: AppLocalizations.of(context)!.focusAreasSelection,
                value: learningPath.focusAreas.join(', '),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Gets display text for learning path level
  /// Maps Level enum to localized string for display
  String _getLevelDisplayText(Level level, BuildContext context) {
    switch (level) {
      case Level.beginner:
        return AppLocalizations.of(context)!.levelBeginner;
      case Level.elementary:
        return AppLocalizations.of(context)!.levelElementary;
      case Level.intermediate:
        return AppLocalizations.of(context)!.levelIntermediate;
      case Level.advanced:
        return AppLocalizations.of(context)!.levelAdvanced;
    }
  }

  /// Builds an info item widget showing title and value
  /// Used to display level and focus areas information
  Widget _buildInfoItem(
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
// LearningPathInfoDisplay(learningPath: learningPath)
