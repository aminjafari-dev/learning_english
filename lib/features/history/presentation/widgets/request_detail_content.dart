// request_detail_content.dart
// Main content widget for the Request Detail page.
// Combines vocabulary history section, phrase history section, and request info.
// Uses a single scroll view for the entire content.
// Reuses daily lessons widgets where possible to avoid code duplication.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/section_header.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/vocabulary_section.dart';
import 'package:learning_english/features/daily_lessons/presentation/widgets/phrases_list_section.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/phrase.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/vocabulary.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_state.dart';
import 'package:learning_english/features/history/presentation/bloc/vocabulary_history_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Main content widget for the Request Detail page
/// Combines vocabulary history section, phrase history section, and request info
/// Uses a single scroll view for unified scrolling experience
/// Reuses daily lessons widgets to avoid code duplication
class RequestDetailContent extends StatelessWidget {
  final VocabularyHistoryState state;

  const RequestDetailContent({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return state.requestDetails.when(
      initial: () => const SizedBox(),
      loading:
          () => const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          ),
      completed: (request) => _buildRequestContent(context, request),
      error: (message) => _buildErrorWidget(context, message),
    );
  }

  /// Builds the main request content with sections
  Widget _buildRequestContent(BuildContext context, dynamic request) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Vocabulary section - reuse daily lessons vocabulary section
          if (request.hasVocabularies) ...[
            SectionHeader(title: AppLocalizations.of(context)!.vocabularyItems),
            GGap.g4,
            _buildVocabularyHistorySection(request.vocabularies),
            GGap.g24,
          ],

          // Phrases section - reuse daily lessons phrases section
          if (request.hasPhrases) ...[
            SectionHeader(title: AppLocalizations.of(context)!.phraseItems),
            GGap.g8,
            _buildPhraseHistorySection(request.phrases),
          ],

          // Add bottom padding to ensure content is not cut off
          GGap.g32,
        ],
      ),
    );
  }

  /// Builds the request header with request info
  Widget _buildRequestHeader(BuildContext context, dynamic request) {
    return Card(
      color: AppTheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: AppTheme.primaryColor, size: 24),
                GGap.g8,
                Expanded(
                  child: GText(
                    'Request ${request.requestId.substring(0, 8)}...',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            GGap.g8,
            Row(
              children: [
                Icon(Icons.access_time, color: AppTheme.accentColor, size: 16),
                GGap.g4,
                GText(
                  _formatDate(request.createdAt),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            GGap.g8,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GText(
                '${request.totalItems} ${AppLocalizations.of(context)!.itemsGenerated}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds vocabulary history section using daily lessons vocabulary section
  Widget _buildVocabularyHistorySection(List<dynamic> vocabularies) {
    // Convert history vocabularies to the format expected by VocabularySection
    final convertedVocabularies =
        vocabularies
            .map(
              (vocab) =>
                  Vocabulary(english: vocab.english, persian: vocab.persian),
            )
            .toList();

    // Create a mock state that the VocabularySection can handle
    final mockState = VocabulariesState.loaded(convertedVocabularies);

    return VocabularySection(state: mockState);
  }

  /// Builds phrase history section using daily lessons phrases section
  Widget _buildPhraseHistorySection(List<dynamic> phrases) {
    // Convert history phrases to the format expected by PhrasesListSection
    final convertedPhrases =
        phrases
            .map(
              (phrase) =>
                  Phrase(english: phrase.english, persian: phrase.persian),
            )
            .toList();

    // Create a mock state that the PhrasesListSection can handle
    final mockState = PhrasesState.loaded(convertedPhrases);

    return PhrasesListSection(phrasesState: mockState);
  }

  /// Builds error widget
  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
          GGap.g16,
          GText(
            AppLocalizations.of(context)!.errorLoadingHistory,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          GGap.g8,
          GText(
            message,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Formats the date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today at ${_formatTime(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${_formatTime(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Formats the time for display
  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

// Example usage:
// RequestDetailContent(state: state)
