// firebase_error_widget.dart
// Reusable widget for displaying Firebase errors with user-friendly messages.
// This widget provides consistent error handling across the app.

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import '../error/firebase_failure.dart';
import 'g_button.dart';
import 'g_gap.dart';

/// Reusable widget for displaying Firebase errors
/// Provides user-friendly error messages and appropriate action buttons
class FirebaseErrorWidget extends StatelessWidget {
  final FirebaseFailure failure;
  final VoidCallback? onRetry;
  final VoidCallback? onClose;
  final VoidCallback? onContactSupport;
  final bool showDetails;

  /// Creates a Firebase error widget
  ///
  /// Parameters:
  /// - failure: The Firebase failure to display
  /// - onRetry: Callback for retry action (only shown if error is recoverable)
  /// - onClose: Callback for close action
  /// - onContactSupport: Callback for contact support action
  /// - showDetails: Whether to show technical error details (for debugging)
  const FirebaseErrorWidget({
    super.key,
    required this.failure,
    this.onRetry,
    this.onClose,
    this.onContactSupport,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.error,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error icon and title
          Row(
            children: [
              Icon(
                _getErrorIcon(),
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GText(
                  _getErrorTitle(l10n),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          GGap.g12,

          // Error message
          GText(
            failure.userFriendlyMessage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          // Technical details (for debugging)
          if (showDetails) ...[
            GGap.g8,
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GText(
                    'Technical Details:',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GGap.g4,
                  GText(
                    'Type: ${failure.runtimeType}',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  if (failure.code != null) ...[
                    GText(
                      'Code: ${failure.code}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                  if (failure.details != null) ...[
                    GText(
                      'Details: ${failure.details}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ],
              ),
            ),
          ],

          GGap.g16,

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Close button
              if (onClose != null) GButton(onPressed: onClose, text: 'Close'),

              // Retry button (only if error is recoverable)
              if (failure.isRecoverable && onRetry != null) ...[
                if (onClose != null) GGap.g8,
                GButton(onPressed: onRetry, text: 'Retry'),
              ],

              // Contact support button (for regional restrictions or non-recoverable errors)
              if (failure.requiresUserAction && onContactSupport != null) ...[
                if (onClose != null ||
                    (failure.isRecoverable && onRetry != null))
                  GGap.g8,
                GButton(onPressed: onContactSupport, text: 'Contact Support'),
              ],
            ],
          ),
        ],
      ),
    );
  }

  /// Returns appropriate error icon based on failure type
  IconData _getErrorIcon() {
    if (failure is FirebaseRegionalFailure) {
      return Icons.location_off;
    } else if (failure is FirebaseNetworkFailure) {
      return Icons.wifi_off;
    } else if (failure is FirebaseAuthFailure) {
      return Icons.lock;
    } else if (failure is FirebaseFirestoreFailure) {
      return Icons.storage;
    } else {
      return Icons.error;
    }
  }

  /// Returns appropriate error title based on failure type
  String _getErrorTitle(AppLocalizations l10n) {
    if (failure is FirebaseRegionalFailure) {
      return 'Regional Restriction';
    } else if (failure is FirebaseNetworkFailure) {
      return 'Network Error';
    } else if (failure is FirebaseAuthFailure) {
      return 'Authentication Error';
    } else if (failure is FirebaseFirestoreFailure) {
      return 'Database Error';
    } else {
      return 'Error';
    }
  }
}

/// SnackBar widget for displaying Firebase errors
class FirebaseErrorSnackBar extends StatelessWidget {
  final FirebaseFailure failure;
  final VoidCallback? onRetry;

  const FirebaseErrorSnackBar({super.key, required this.failure, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SnackBar(
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      content: Row(
        children: [
          Icon(
            _getErrorIcon(),
            color: Theme.of(context).colorScheme.error,
            size: 20,
          ),
          GGap.g12,
          Expanded(
            child: GText(
              failure.userFriendlyMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
      action:
          failure.isRecoverable && onRetry != null
              ? SnackBarAction(
                label: 'Retry',
                onPressed: onRetry!,
                textColor: Theme.of(context).colorScheme.error,
              )
              : null,
      duration: const Duration(seconds: 4),
    );
  }

  /// Returns appropriate error icon based on failure type
  IconData _getErrorIcon() {
    if (failure is FirebaseRegionalFailure) {
      return Icons.location_off;
    } else if (failure is FirebaseNetworkFailure) {
      return Icons.wifi_off;
    } else if (failure is FirebaseAuthFailure) {
      return Icons.lock;
    } else if (failure is FirebaseFirestoreFailure) {
      return Icons.storage;
    } else {
      return Icons.error;
    }
  }
}

/// Dialog widget for displaying Firebase errors
class FirebaseErrorDialog extends StatelessWidget {
  final FirebaseFailure failure;
  final VoidCallback? onRetry;
  final VoidCallback? onClose;
  final VoidCallback? onContactSupport;

  const FirebaseErrorDialog({
    super.key,
    required this.failure,
    this.onRetry,
    this.onClose,
    this.onContactSupport,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(_getErrorIcon(), color: Theme.of(context).colorScheme.error),
          GGap.g8,
          GText(_getErrorTitle()),
        ],
      ),
      content: FirebaseErrorWidget(
        failure: failure,
        onRetry: onRetry,
        onClose: onClose,
        onContactSupport: onContactSupport,
        showDetails: true, // Show details in dialog
      ),
      actions: [
        if (onClose != null)
          TextButton(onPressed: onClose, child: const GText('Close')),
        if (failure.isRecoverable && onRetry != null)
          TextButton(onPressed: onRetry, child: const GText('Retry')),
        if (failure.requiresUserAction && onContactSupport != null)
          TextButton(
            onPressed: onContactSupport,
            child: const GText('Contact Support'),
          ),
      ],
    );
  }

  /// Returns appropriate error icon based on failure type
  IconData _getErrorIcon() {
    if (failure is FirebaseRegionalFailure) {
      return Icons.location_off;
    } else if (failure is FirebaseNetworkFailure) {
      return Icons.wifi_off;
    } else if (failure is FirebaseAuthFailure) {
      return Icons.lock;
    } else if (failure is FirebaseFirestoreFailure) {
      return Icons.storage;
    } else {
      return Icons.error;
    }
  }

  /// Returns appropriate error title based on failure type
  String _getErrorTitle() {
    if (failure is FirebaseRegionalFailure) {
      return 'Regional Restriction';
    } else if (failure is FirebaseNetworkFailure) {
      return 'Network Error';
    } else if (failure is FirebaseAuthFailure) {
      return 'Authentication Error';
    } else if (failure is FirebaseFirestoreFailure) {
      return 'Database Error';
    } else {
      return 'Error';
    }
  }
}
