import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/widgets/g_scaffold.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/widgets/g_button.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/core/router/page_name.dart';
import '../bloc/vocabulary_history_bloc.dart';
import '../bloc/vocabulary_history_event.dart';
import '../bloc/vocabulary_history_state.dart';
import '../widgets/history_request_card.dart';

/// Main page for displaying vocabulary and phrase history
/// This page shows a list of all learning requests made by the user,
/// organized by request date and ID
///
/// Usage Example:
///   Navigator.of(context).pushNamed(PageName.vocabularyHistory);
///
/// This page follows the app's design patterns and uses the established
/// color scheme and UI components.
class VocabularyHistoryPage extends StatelessWidget {
  const VocabularyHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GScaffold(
      appBar: AppBar(
        title: GText(
          AppLocalizations.of(context)!.history,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.white,
        actions: [
          BlocBuilder<VocabularyHistoryBloc, VocabularyHistoryState>(
            bloc:
                getIt<VocabularyHistoryBloc>()
                  ..add(const VocabularyHistoryEvent.loadHistoryRequests()),
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  getIt<VocabularyHistoryBloc>().add(
                    const VocabularyHistoryEvent.refreshHistory(),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<VocabularyHistoryBloc, VocabularyHistoryState>(
        bloc: getIt<VocabularyHistoryBloc>(),
        builder: (context, state) {
          print('🔄 [HISTORY] Current state: ${state.historyRequests}');
          return state.historyRequests.when(
            initial: () {
              print('🔄 [HISTORY] Initial state - triggering load');
              // Trigger load when in initial state
              WidgetsBinding.instance.addPostFrameCallback((_) {
                getIt<VocabularyHistoryBloc>().add(
                  const VocabularyHistoryEvent.loadHistoryRequests(),
                );
              });
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              );
            },
            loading:
                () => const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                ),
            completed: (requests) {
              print('🔄 [HISTORY] Completed with ${requests.length} requests');
              return _buildHistoryList(context, requests);
            },
            error: (message) {
              print('❌ [HISTORY] Error: $message');
              return _buildErrorWidget(context, message);
            },
          );
        },
      ),
    );
  }


  /// Builds the history list widget
  Widget _buildHistoryList(BuildContext context, List<dynamic> requests) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: AppTheme.accentColor),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: HistoryRequestCard(
                  request: request,
                  onTap:
                      () =>
                          _navigateToRequestDetails(context, request.requestId),
                ),
              );
            },
          ),
        ),
      ],
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
          GButton(
            text: AppLocalizations.of(context)!.errorRetry,
            onPressed: () {
              getIt<VocabularyHistoryBloc>().add(
                const VocabularyHistoryEvent.refreshHistory(),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Navigates to request details page
  void _navigateToRequestDetails(BuildContext context, String requestId) {
    Navigator.of(
      context,
    ).pushNamed(PageName.requestDetails, arguments: requestId);
  }
}
