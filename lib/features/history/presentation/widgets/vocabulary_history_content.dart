// vocabulary_history_content.dart
// Main content widget for the Vocabulary History page.
// Combines history requests list, empty state, and error handling.
// Uses a single scroll view for the entire content.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/widgets/global_widget/g_button.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/features/history/presentation/bloc/vocabulary_history_state.dart';
import 'package:learning_english/features/history/presentation/widgets/history_request_card.dart';
import 'package:learning_english/l10n/app_localizations.dart';

/// Main content widget for the Vocabulary History page
/// Combines history requests list, empty state, and error handling
/// Uses a single scroll view for unified scrolling experience
class VocabularyHistoryContent extends StatelessWidget {
  final VocabularyHistoryState state;
  final VoidCallback onRetry;
  final Function(String) onRequestTap;

  const VocabularyHistoryContent({
    super.key,
    required this.state,
    required this.onRetry,
    required this.onRequestTap,
  });

  @override
  Widget build(BuildContext context) {
    return state.historyRequests.when(
      initial:
          () => Center(
            child: CircularProgressIndicator(color: AppTheme.primary(context)),
          ),
      loading:
          () => Center(
            child: CircularProgressIndicator(color: AppTheme.primary(context)),
          ),
      completed: (requests) => _buildHistoryList(context, requests),
      error: (message) => _buildErrorWidget(context, message),
    );
  }

  /// Builds the history list when data is loaded
  Widget _buildHistoryList(BuildContext context, List<dynamic> requests) {
    if (requests.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              GText(
                AppLocalizations.of(context)!.historyRequests,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              GText(
                '${requests.length} requests',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: HistoryRequestCard(
                  request: request,
                  onTap: () => onRequestTap(request.requestId),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds empty state when no history is found
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: AppTheme.accent(context)),
          GGap.g16,
          GText(
            AppLocalizations.of(context)!.noHistoryFound,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          GGap.g8,
          GText(
            'Start learning to see your history here',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  /// Builds error widget when history fails to load
  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppTheme.error(context)),
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
          GButton(
            text: AppLocalizations.of(context)!.errorRetry,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

// Example usage:
// VocabularyHistoryContent(
//   state: state,
//   onRetry: () => bloc.add(const VocabularyHistoryEvent.refreshHistory()),
//   onRequestTap: (requestId) => Navigator.pushNamed(context, PageName.requestDetails, arguments: requestId),
// )
