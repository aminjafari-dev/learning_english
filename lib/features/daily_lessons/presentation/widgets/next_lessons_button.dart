// next_lessons_button.dart
// A simple button to navigate to the next lesson within a course context.
// Shows nothing if course context is not available.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/global_widget/g_button.dart';
import 'package:learning_english/l10n/app_localizations.dart';

/// A thin wrapper around [GButton] that triggers moving to the next lesson.
///
/// Usage example:
/// NextLessonsButton(
///   pathId: 'path123',
///   courseNumber: 3,
///   onNext: () { /* navigate to course 4 */ },
/// )
class NextLessonsButton extends StatelessWidget {
  final String? pathId;
  final int? courseNumber;
  final VoidCallback? onNext;

  const NextLessonsButton({
    super.key,
    this.pathId,
    this.courseNumber,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    // Only render when we have a course context
    if (pathId == null || courseNumber == null) {
      return const SizedBox.shrink();
    }

    return GButton(
      text: AppLocalizations.of(context)!.nextLessons,
      onPressed: onNext,
    );
  }
}
