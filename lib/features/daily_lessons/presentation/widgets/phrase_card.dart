// phrase_card.dart
// Widget for displaying a phrase (English and Persian translation).

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import '../../domain/entities/phrase.dart';

class PhraseCard extends StatelessWidget {
  final Phrase phrase;
  const PhraseCard({Key? key, required this.phrase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GText(
            phrase.english,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
           GGap.g4,
          GText(
            phrase.persian,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.hint),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}

// Example usage:
// PhraseCard(phrase: Phrase(english: 'I owe it to myself', persian: 'به اون امیدوارم'))
