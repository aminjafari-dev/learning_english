import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import '../../domain/entities/phrase_history_item.dart';

/// Card widget for displaying phrase history items
/// This widget shows a phrase item with its English and Persian translations
///
/// Usage Example:
///   PhraseHistoryCard(
///     phrase: phraseHistoryItem,
///   );
///
/// This widget follows the app's design patterns and uses the established
/// color scheme and UI components.
class PhraseHistoryCard extends StatelessWidget {
  final PhraseHistoryItem phrase;


  const PhraseHistoryCard({super.key, required this.phrase});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.chat_bubble, color: AppTheme.primaryColor, size: 16),
                GGap.g8,
                GText(
                  'Phrase',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (phrase.isUsed)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: GText(
                      'Used',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
            GGap.g8,
            GText(
              phrase.english,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            GGap.g4,
            GText(
              phrase.persian,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.accentColor),
            ),
          ],
        ),
      ),
    );
  }
}
