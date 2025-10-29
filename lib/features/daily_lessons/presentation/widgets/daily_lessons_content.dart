// daily_lessons_content.dart
// Main content widget for the Daily Lessons page.
// Combines vocabularies section, phrases section, and refresh button.
// Uses a single scroll view for the entire content.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/section_header.dart';
import 'package:learning_english/core/widgets/vocabulary_section.dart';
import 'package:learning_english/core/widgets/phrases_list_section.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/refresh_button.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/user_preferences_display.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/course_completion_button.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_state.dart';
import 'package:learning_english/l10n/app_localizations.dart';

/// Main content widget for the Daily Lessons page
/// Combines vocabularies section, phrases section, and refresh button
/// Uses a single scroll view for unified scrolling experience
class DailyLessonsContent extends StatelessWidget {
  final DailyLessonsState state;
  final String? pathId;
  final int? courseNumber;
  final VoidCallback? onCompleteCourse;
  final bool isCompletingCourse;

  const DailyLessonsContent({
    super.key,
    required this.state,
    this.pathId,
    this.courseNumber,
    this.onCompleteCourse,
    this.isCompletingCourse = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GGap.g16,
          // User Preferences Display - shows user's level and focus areas
          const UserPreferencesDisplay(),
          GGap.g16,
          SectionHeader(title: AppLocalizations.of(context)!.vocabularies),
          GGap.g4,
          VocabularySection(state: state.vocabularies),
          GGap.g24,
          SectionHeader(title: AppLocalizations.of(context)!.phrases),
          GGap.g8,
          PhrasesListSection(phrasesState: state.phrases),
          GGap.g16,
          // Course completion button (only shown when course context is available)
          CourseCompletionButton(
            pathId: pathId,
            courseNumber: courseNumber,
            onComplete: onCompleteCourse,
            isLoading: isCompletingCourse,
          ),
          RefreshButton(isRefreshing: state.isRefreshing),
          // Add bottom padding to ensure content is not cut off
          GGap.g32,
        ],
      ),
    );
  }
}

// Example usage:
// DailyLessonsContent(state: state)
