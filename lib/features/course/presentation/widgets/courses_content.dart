// courses_content.dart
// Main content widget for the Courses page.
// Combines vocabularies section, phrases section, and refresh button.
// Uses a single scroll view for the entire content.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:learning_english/features/course/presentation/widgets/section_header.dart';
import 'package:learning_english/core/widgets/vocabulary_section.dart';
import 'package:learning_english/core/widgets/phrases_list_section.dart';
import 'package:learning_english/features/course/presentation/widgets/user_preferences_display.dart';
import 'package:learning_english/features/course/presentation/widgets/next_lessons_button.dart';
import 'package:learning_english/features/course/presentation/bloc/courses_state.dart';
import 'package:learning_english/l10n/app_localizations.dart';

/// Main content widget for the Courses page
/// Combines vocabularies section, phrases section, and refresh button
/// Uses a single scroll view for unified scrolling experience
class CoursesContent extends StatelessWidget {
  final CoursesState state;
  final String? pathId;
  final int? courseNumber;
  final VoidCallback? onNextLessons;

  const CoursesContent({
    super.key,
    required this.state,
    this.pathId,
    this.courseNumber,
    this.onNextLessons,
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
          // Next Lessons button (only shown when course context is available)
          NextLessonsButton(
            pathId: pathId,
            courseNumber: courseNumber,
            onNext: onNextLessons,
          ),
          GGap.g32,
        ],
      ),
    );
  }
}

// Example usage:
// CoursesContent(state: state)
