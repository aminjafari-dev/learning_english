// courses_error_widget.dart
// Error widget for the Courses page that displays a user-friendly error message
// with a retry button when lessons fail to load.
// Provides a centered, visually appealing error UI instead of showing error messages
// at the bottom of vocabularies/phrases sections.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/widgets/global_widget/g_button.dart';
import 'package:learning_english/core/widgets/global_widget/g_gap.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import 'package:learning_english/l10n/app_localizations.dart';

/// Error widget displayed when course lessons fail to load.
/// Shows an error icon, message, and a retry button.
/// 
/// Usage example:
/// CoursesErrorWidget(
///   errorMessage: 'Failed to load lessons',
///   onRetry: () {
///     // Trigger retry logic
///   },
/// )
class CoursesErrorWidget extends StatelessWidget {
  /// The error message to display
  final String errorMessage;
  
  /// Callback function triggered when retry button is pressed
  final VoidCallback onRetry;

  const CoursesErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error icon with animated appearance
            Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: AppTheme.error(context).withValues(alpha: 0.7),
            ),
            GGap.g24,
            
            // Error title
            GText(
              AppLocalizations.of(context)!.errorGeneric,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.text(context),
              ),
              textAlign: TextAlign.center,
            ),
            GGap.g12,
            
            // Error message
            GText(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.hint(context),
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            GGap.g32,
            
            // Retry button with icon
            GButton(
              text: AppLocalizations.of(context)!.errorRetry,
              icon: const Icon(Icons.refresh_rounded),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

