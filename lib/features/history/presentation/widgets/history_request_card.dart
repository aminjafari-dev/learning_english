import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import '../../domain/entities/history_request.dart';

/// Card widget for displaying history requests
/// This widget shows a summary of a learning request including
/// the number of vocabularies and phrases generated
///
/// Usage Example:
///   HistoryRequestCard(
///     request: historyRequest,
///     onTap: () => navigateToDetails(request.requestId),
///   );
///
/// This widget follows the app's design patterns and uses the established
/// color scheme and UI components.
class HistoryRequestCard extends StatelessWidget {
  final HistoryRequest request;
  final VoidCallback onTap;

  const HistoryRequestCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.history, color: AppTheme.primaryColor, size: 20),
                  GGap.g8,
                  Expanded(
                    child: GText(
                      'Request ${request.requestId.substring(0, 8)}...',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.accentColor,
                    size: 16,
                  ),
                ],
              ),
              GGap.g12,
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
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              GGap.g8,
              Row(
                children: [
                  if (request.hasVocabularies) ...[
                    Icon(Icons.book, color: AppTheme.primaryColor, size: 16),
                    GGap.g4,
                    GText(
                      '${request.vocabularyCount} vocabularies',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    GGap.g12,
                  ],
                  if (request.hasPhrases) ...[
                    Icon(
                      Icons.chat_bubble,
                      color: AppTheme.primaryColor,
                      size: 16,
                    ),
                    GGap.g4,
                    GText(
                      '${request.phraseCount} phrases',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              GGap.g8,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GText(
                  '${request.totalItems} ${AppLocalizations.of(context)!.itemsGenerated}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
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
