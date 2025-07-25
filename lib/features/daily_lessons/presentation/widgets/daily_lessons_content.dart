// daily_lessons_content.dart
// Main content widget for the Daily Lessons page.
// Combines vocabularies section, phrases section, and refresh button.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/section_header.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/vocabulary_section.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/phrases_list_section.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/refresh_button.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Main content widget for the Daily Lessons page
/// Combines vocabularies section, phrases section, and refresh button
class DailyLessonsContent extends StatelessWidget {
  final DailyLessonsState state;

  const DailyLessonsContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GGap.g16,
        SectionHeader(title: AppLocalizations.of(context)!.vocabularies),
        GGap.g4,
        VocabularySection(state: state.vocabularies),
        GGap.g24,
        SectionHeader(title: AppLocalizations.of(context)!.phrases),
        GGap.g8,
        PhrasesListSection(phrasesState: state.phrases),
        GGap.g16,
        RefreshButton(isRefreshing: state.isRefreshing),
      ],
    );
  }
}

// Example usage:
// DailyLessonsContent(state: state)
