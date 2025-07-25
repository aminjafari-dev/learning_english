// phrases_list_section.dart
// Widget that displays the phrases list section.
// Handles different states: initial, loading, loaded, and error.
// Now works within a single scroll view instead of having its own scroll controller.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/phrase_card.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_state.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/phrase.dart';

/// Widget that displays the phrases list section
/// Handles different states: initial, loading, loaded, and error
/// Works within a single scroll view for unified scrolling experience
class PhrasesListSection extends StatelessWidget {
  final PhrasesState phrasesState;

  const PhrasesListSection({super.key, required this.phrasesState});

  @override
  Widget build(BuildContext context) {
    return phrasesState.when(
      initial: () => const SizedBox(),
      loading: () => const Center(child: CircularProgressIndicator()),
      loaded: (phrases) => _buildPhrasesList(phrases),
      error: (msg) => _buildErrorWidget(msg),
    );
  }

  /// Builds the phrases list when data is loaded
  /// Uses Column instead of ListView for single scroll view compatibility
  Widget _buildPhrasesList(List<Phrase> phrases) {
    return Column(
      children:
          phrases.asMap().entries.map((entry) {
            final index = entry.key;
            final phrase = entry.value;
            return Column(
              children: [
                PhraseCard(phrase: phrase),
                // Add gap between phrases, but not after the last one
                if (index < phrases.length - 1) GGap.g8,
              ],
            );
          }).toList(),
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
