// daily_lessons_page.dart
// Main page for the Daily Lessons feature.
// This page displays vocabularies, phrases, and lesson sections, using Bloc for state management.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/widgets/g_scaffold.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/widgets/g_button.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_bloc.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_event.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_state.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/section_header.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/phrase_card.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/vocabulary_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// The main Daily Lessons page widget.
class DailyLessonsPage extends StatelessWidget {
  const DailyLessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use getIt for dependency injection instead of BlocProvider in the UI
    final bloc =
        getIt<DailyLessonsBloc>()
          ..add(const DailyLessonsEvent.fetchVocabularies())
          ..add(const DailyLessonsEvent.fetchPhrases());
    return GScaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: GText(
          AppLocalizations.of(context)!.yourDailyLessons,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<DailyLessonsBloc, DailyLessonsState>(
          bloc: bloc,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GGap.g16,
                SectionHeader(
                  title: AppLocalizations.of(context)!.vocabularies,
                ),
                GGap.g4,
                VocabularySection(state: state.vocabularies),
                GGap.g24,
                SectionHeader(title: AppLocalizations.of(context)!.phrases),
                GGap.g8,
                Expanded(
                  child: state.phrases.when(
                    initial: () => const SizedBox(),
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                    loaded:
                        (phrases) => ListView.separated(
                          itemCount: phrases.length,
                          separatorBuilder: (_, __) => GGap.g8,
                          itemBuilder:
                              (context, index) =>
                                  PhraseCard(phrase: phrases[index]),
                        ),
                    error:
                        (msg) => Center(
                          child: GText(
                            msg,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                  ),
                ),
                GGap.g16,
                GButton(
                  text: AppLocalizations.of(context)!.refreshLessons,
                  onPressed:
                      () => bloc.add(const DailyLessonsEvent.refreshLessons()),
                  color: AppTheme.gold,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Example usage:
// Navigator.of(context).pushNamed(PageName.dailyLessons);
