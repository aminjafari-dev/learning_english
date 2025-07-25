// phrases_list_section.dart
// Widget that displays the phrases list section.
// Handles different states: initial, loading, loaded, and error.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/phrase_card.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_state.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/phrase.dart';

/// Widget that displays the phrases list section
/// Handles different states: initial, loading, loaded, and error
class PhrasesListSection extends StatelessWidget {
  final PhrasesState phrasesState;

  const PhrasesListSection({super.key, required this.phrasesState});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: phrasesState.when(
        initial: () => const SizedBox(),
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (phrases) => _buildPhrasesList(phrases),
        error: (msg) => _buildErrorWidget(msg),
      ),
    );
  }

  /// Builds the phrases list when data is loaded
  Widget _buildPhrasesList(List<Phrase> phrases) {
    return ListView.separated(
      itemCount: phrases.length,
      separatorBuilder: (_, __) => GGap.g8,
      itemBuilder: (context, index) => PhraseCard(phrase: phrases[index]),
    );
  }

  /// Builds error widget when phrases fail to load
  Widget _buildErrorWidget(String message) {
    return Center(
      child: GText(message, style: const TextStyle(color: Colors.red)),
    );
  }
}

// Example usage:
// PhrasesListSection(phrasesState: state.phrases)
