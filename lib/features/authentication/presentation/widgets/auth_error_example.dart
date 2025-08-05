// auth_error_example.dart
// Example widget demonstrating Firebase error handling in authentication.
// This shows how to use FirebaseErrorWidget with authentication failures.

import 'package:flutter/material.dart';
import 'package:learning_english/core/widgets/firebase_error_widget.dart';
import 'package:learning_english/core/error/firebase_failure.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/features/authentication/domain/repositories/auth_repository.dart';

/// Example widget showing how to handle Firebase errors in authentication
class AuthErrorExample extends StatelessWidget {
  final AuthRepository authRepository;

  const AuthErrorExample({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication Error Handling')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Example 1: Google Sign-In with error handling
            ElevatedButton(
              onPressed: () => _handleGoogleSignIn(context),
              child: const Text('Sign In with Google'),
            ),
            const SizedBox(height: 16),

            // Example 2: Show different types of Firebase errors
            ElevatedButton(
              onPressed: () => _showFirebaseErrorDialog(context),
              child: const Text('Show Firebase Error Dialog'),
            ),
            const SizedBox(height: 16),

            // Example 3: Show error snackbar
            ElevatedButton(
              onPressed: () => _showFirebaseErrorSnackBar(context),
              child: const Text('Show Firebase Error SnackBar'),
            ),
            const SizedBox(height: 16),

            // Example 4: Show error widget inline
            ElevatedButton(
              onPressed: () => _showFirebaseErrorWidget(context),
              child: const Text('Show Firebase Error Widget'),
            ),
          ],
        ),
      ),
    );
  }

  /// Handles Google Sign-In with proper error handling
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final result = await authRepository.signInWithGoogle();

      result.fold(
        (failure) {
          // Show error using FirebaseErrorWidget
          _showErrorDialog(context, failure);
        },
        (user) {
          // Handle successful sign-in
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome ${user.name}!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      );
    } catch (e) {
      // Handle unexpected errors
      _showErrorDialog(
        context,
        ServerFailure('Unexpected error during sign-in: ${e.toString()}'),
      );
    }
  }

  /// Shows a dialog with Firebase error details
  void _showErrorDialog(BuildContext context, Failure failure) {
    // Handle non-Firebase failures
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(failure.message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  /// Shows different types of Firebase errors for demonstration
  void _showFirebaseErrorDialog(BuildContext context) {
    final errors = [
      FirebaseAuthFailure(
        'User not found',
        code: 'user-not-found',
        details: 'The user account does not exist',
      ),
      FirebaseNetworkFailure.forNetworkError('Connection timeout', 408),
      FirebaseRegionalFailure.forRegion(
        'Iran',
        'authentication',
        'Firebase services are restricted in this region',
      ),
      FirebaseFirestoreFailure(
        'Permission denied',
        code: 'permission-denied',
        details: 'User does not have permission to access this resource',
      ),
    ];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Firebase Error Examples'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: errors.length,
                itemBuilder: (context, index) {
                  final error = errors[index];
                  return Card(
                    child: ListTile(
                      title: Text(error.runtimeType.toString()),
                      subtitle: Text(error.userFriendlyMessage),
                      trailing: Icon(
                        error.isRecoverable ? Icons.refresh : Icons.error,
                        color: error.isRecoverable ? Colors.orange : Colors.red,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder:
                              (context) => FirebaseErrorDialog(
                                failure: error,
                                onRetry:
                                    error.isRecoverable
                                        ? () {
                                          Navigator.of(context).pop();
                                          // Retry logic here
                                        }
                                        : null,
                                onClose: () => Navigator.of(context).pop(),
                                onContactSupport:
                                    error.requiresUserAction
                                        ? () {
                                          Navigator.of(context).pop();
                                          _contactSupport();
                                        }
                                        : null,
                              ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  /// Shows a Firebase error snackbar
  void _showFirebaseErrorSnackBar(BuildContext context) {
    final error = FirebaseNetworkFailure.forNetworkError(
      'Network connection failed',
      500,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        content: Row(
          children: [
            Icon(
              Icons.wifi_off,
              color: Theme.of(context).colorScheme.error,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                error.userFriendlyMessage,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            // Retry logic here
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Retrying...')));
          },
          textColor: Theme.of(context).colorScheme.error,
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Shows a Firebase error widget inline
  void _showFirebaseErrorWidget(BuildContext context) {
    final error = FirebaseAuthFailure(
      'Invalid credentials',
      code: 'invalid-credential',
      details: 'The provided credentials are invalid',
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Inline Error Widget'),
            content: FirebaseErrorWidget(
              failure: error,
              onRetry: () {
                Navigator.of(context).pop();
                // Retry logic here
              },
              onClose: () => Navigator.of(context).pop(),
              showDetails: true, // Show technical details for debugging
            ),
          ),
    );
  }

  /// Contact support function
  void _contactSupport() {
    // Implement support contact logic
    // This could open an email client, navigate to a support page, etc.
    print('Contacting support...');
  }
}
