import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/widgets/g_scaffold.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import '../bloc/vocabulary_history_bloc.dart';
import '../bloc/vocabulary_history_event.dart';
import '../bloc/vocabulary_history_state.dart';
import '../widgets/vocabulary_history_card.dart';
import '../widgets/phrase_history_card.dart';

/// Detail page for displaying vocabulary and phrases for a specific request
/// This page shows all the vocabulary and phrase items that were generated
/// for a specific learning request
///
/// Usage Example:
///   Navigator.of(context).pushNamed(
///     PageName.requestDetails,
///     arguments: requestId,
///   );
///
/// This page follows the app's design patterns and uses the established
/// color scheme and UI components.
class RequestDetailPage extends StatelessWidget {
  final String requestId;

  const RequestDetailPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return  GScaffold(
        appBar: AppBar(
          title: GText(
            AppLocalizations.of(context)!.requestDetails,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          backgroundColor: AppTheme.surface,
          foregroundColor: AppTheme.white,
        ),
        body: BlocBuilder<VocabularyHistoryBloc, VocabularyHistoryState>(
          bloc: getIt<VocabularyHistoryBloc>()..add(VocabularyHistoryEvent.loadRequestDetails(requestId: requestId)),
          builder: (context, state) {
            return state.requestDetails.when(
              initial: () => const SizedBox(),
              loading:
                  () => const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  ),
              completed: (request) => _buildRequestDetails(context, request),
              error: (message) => _buildErrorWidget(context, message),
            );
          },
        ),
      
    );
  }

  /// Builds the request details widget
  Widget _buildRequestDetails(BuildContext context, dynamic request) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Request header
          Card(
            color: AppTheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                      GGap.g8,
                      Expanded(
                        child: GText(
                          'Request ${request.requestId.substring(0, 8)}...',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
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
                      Icon(
                        Icons.access_time,
                        color: AppTheme.accentColor,
                        size: 16,
                      ),
                      GGap.g4,
                      GText(
                        _formatDate(request.createdAt),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  GGap.g8,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
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
          ),
          GGap.g24,

          // Vocabulary section
          if (request.hasVocabularies) ...[
            GText(
              AppLocalizations.of(context)!.vocabularyItems,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            GGap.g12,
            ...request.vocabularies.map(
              (vocabulary) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: VocabularyHistoryCard(vocabulary: vocabulary),
              ),
            ),
            GGap.g24,
          ],

          // Phrases section
          if (request.hasPhrases) ...[
            GText(
              AppLocalizations.of(context)!.phraseItems,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            GGap.g12,
            ...request.phrases.map(
              (phrase) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: PhraseHistoryCard(phrase: phrase),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds the error widget
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
          GGap.g16,
          ElevatedButton(
            onPressed: () {
              getIt<VocabularyHistoryBloc>().add(
                VocabularyHistoryEvent.loadRequestDetails(requestId: requestId),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: AppTheme.backgroundColor,
            ),
            child: GText(AppLocalizations.of(context)!.errorRetry),
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
