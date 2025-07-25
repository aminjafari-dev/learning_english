// vocabulary_section.dart
// Widget for displaying the vocabularies section.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import '../bloc/daily_lessons_state.dart';

class VocabularySection extends StatelessWidget {
  final VocabulariesState state;
  const VocabularySection({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.when(
      initial: () => const SizedBox(),
      loading: () => const Center(child: CircularProgressIndicator()),
      loaded:
          (vocabularies) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                vocabularies
                    .map(
                      (vocab) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Row(
                          children: [
                            GText(
                              vocab.english,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            GGap.g8,
                            GText(
                              vocab.persian,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppTheme.hint),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
          ),
      error: (msg) => GText(msg, style: const TextStyle(color: Colors.red)),
    );
  }
}

// Example usage:
// VocabularySection(state: state.vocabularies)
