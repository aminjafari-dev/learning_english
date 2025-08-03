import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import '../../domain/entities/history_request.dart';
import '../../../daily_lessons/data/models/level_type.dart';

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
                  // Icon(Icons.history, color: AppTheme.primaryColor, size: 20),
                  // GGap.g8,
                  Expanded(
                    child: GText(
                      _formatFocusAreas(request.focusAreas, context),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Icon(
                  //   Icons.arrow_forward_ios,
                  //   color: AppTheme.accentColor,
                  //   size: 16,
                  // ),
                ],
              ),
              GGap.g12,
              Row(
                children: [
                  Icon(Icons.access_time, color: AppTheme.accent, size: 16),
                  GGap.g4,
                  GText(
                    _formatDate(request.createdAt, context),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Spacer(),
                  Icon(Icons.school, color: AppTheme.accent, size: 16),
                  GGap.g4,
                  GText(
                    _formatUserLevel(request.userLevel, context),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              GGap.g8,
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   decoration: BoxDecoration(
              //     color: AppTheme.primaryColor.withOpacity(0.1),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: GText(
              //     '${request.totalItems} ${AppLocalizations.of(context)!.itemsGenerated}',
              //     style: Theme.of(context).textTheme.bodySmall?.copyWith(
              //       color: AppTheme.primaryColor,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  /// Formats the date for display using localized strings
  /// Supports both English and Persian date formatting
  String _formatDate(DateTime date, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '${l10n.today} ${l10n.at} ${_formatTime(date)}';
    } else if (difference.inDays == 1) {
      return '${l10n.yesterday} ${l10n.at} ${_formatTime(date)}';
    } else if (difference.inDays < 7) {
      return l10n.daysAgo(difference.inDays);
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Formats the time for display
  /// Returns time in HH:MM format
  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Formats focus areas for display using localized strings
  /// Converts focus areas list to a readable string
  /// Uses localization for general learning fallback
  String _formatFocusAreas(List<String> focusAreas, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (focusAreas.isEmpty) {
      return l10n.generalLearning;
    }

    // Capitalize and join focus areas
    return focusAreas
        .map(
          (area) => area
              .split('_')
              .map(
                (word) =>
                    word.isNotEmpty
                        ? '${word[0].toUpperCase()}${word.substring(1)}'
                        : word,
              )
              .join(' '),
        )
        .join(', ');
  }

  /// Formats user level for display using localized strings
  /// Converts UserLevel enum to a readable string
  String _formatUserLevel(UserLevel userLevel, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (userLevel) {
      case UserLevel.beginner:
        return l10n.levelBeginnerShort;
      case UserLevel.elementary:
        return l10n.levelElementaryShort;
      case UserLevel.intermediate:
        return l10n.levelIntermediateShort;
      case UserLevel.advanced:
        return l10n.levelAdvancedShort;
    }
  }
}
