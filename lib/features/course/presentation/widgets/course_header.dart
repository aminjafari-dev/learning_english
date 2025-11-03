// daily_lessons_header.dart
// Header widget for the Daily Lessons page.
// Displays the title and settings button.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/l10n/app_localizations.dart';

/// Header widget for the Daily Lessons page
/// Displays the main title and settings button
class CoursesHeader extends StatelessWidget {
  final String? pathId;
  final int? courseNumber;
  final bool? isCompleted;

  const CoursesHeader({
    super.key,
    this.pathId,
    this.courseNumber,
    this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GText(
            _getTitle(context),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  /// Gets the appropriate title based on context
  String _getTitle(BuildContext context) {
    if (pathId != null && courseNumber != null) {
      if (isCompleted == true) {
        return 'Review Course $courseNumber';
      } else {
        return 'Course $courseNumber';
      }
    }
    return AppLocalizations.of(context)!.yourDailyLessons;
  }
}

// Example usage:
// DailyLessonsHeader()
