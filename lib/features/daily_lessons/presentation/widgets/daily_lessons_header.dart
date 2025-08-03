// daily_lessons_header.dart
// Header widget for the Daily Lessons page.
// Displays the title and settings button.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Header widget for the Daily Lessons page
/// Displays the main title and settings button
class DailyLessonsHeader extends StatelessWidget {
  const DailyLessonsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GText(
            AppLocalizations.of(context)!.yourDailyLessons,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// Example usage:
// DailyLessonsHeader()
