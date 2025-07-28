// firebase_error_handler.dart
// Firebase error handler utility for catching and classifying all Firebase errors.
// This class provides methods to handle different types of Firebase exceptions
// and convert them to appropriate failure types.

import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_failure.dart';

/// Firebase error handler utility class
/// Provides methods to catch and classify Firebase errors
class FirebaseErrorHandler {
  /// Handles any Firebase-related exception and returns appropriate failure
  /// This is the main entry point for Firebase error handling
  ///
  /// Parameters:
  /// - exception: The caught exception
  /// - context: Optional context for better error classification
  ///
  /// Returns: FirebaseFailure with appropriate classification
  static FirebaseFailure handleException(dynamic exception, {String? context}) {
    print('🔥 [FIREBASE_ERROR] Handling exception: ${exception.runtimeType}');
    print('🔥 [FIREBASE_ERROR] Exception details: $exception');

    // Handle Firebase Auth exceptions
    if (exception is fb_auth.FirebaseAuthException) {
      return _handleAuthException(exception, context);
    }

    // Handle Firestore exceptions
    if (exception is FirebaseException) {
      return _handleFirestoreException(exception, context);
    }

    // Handle Firebase Core exceptions
    if (exception is FirebaseException) {
      return _handleFirebaseCoreException(exception, context);
    }

    // Handle network-related errors (403, regional restrictions, etc.)
    if (_isRegionalRestrictionError(exception)) {
      return _handleRegionalRestriction(exception, context);
    }

    // Handle network errors
    if (_isNetworkError(exception)) {
      return _handleNetworkError(exception, context);
    }

    // Handle generic Firebase errors
    return _handleGenericError(exception, context);
  }

  /// Handles Firebase Auth exceptions
  static FirebaseAuthFailure _handleAuthException(
    fb_auth.FirebaseAuthException exception,
    String? context,
  ) {
    print('🔥 [FIREBASE_ERROR] Auth exception: ${exception.code}');
    print('🔥 [FIREBASE_ERROR] Auth message: ${exception.message}');

    return FirebaseAuthFailure.fromException(exception);
  }

  /// Handles Firestore exceptions
  static FirebaseFirestoreFailure _handleFirestoreException(
    FirebaseException exception,
    String? context,
  ) {
    print('🔥 [FIREBASE_ERROR] Firestore exception: ${exception.code}');
    print('🔥 [FIREBASE_ERROR] Firestore message: ${exception.message}');

    return FirebaseFirestoreFailure.fromException(exception);
  }

  /// Handles Firebase Core exceptions
  static FirebaseFailure _handleFirebaseCoreException(
    FirebaseException exception,
    String? context,
  ) {
    print('🔥 [FIREBASE_ERROR] Firebase Core exception: ${exception.code}');
    print('🔥 [FIREBASE_ERROR] Firebase Core message: ${exception.message}');

    // Check if it's a regional restriction
    if (_isRegionalRestrictionError(exception)) {
      return _handleRegionalRestriction(exception, context);
    }

    // Check if it's a network error
    if (_isNetworkError(exception)) {
      return _handleNetworkError(exception, context);
    }

    return FirebaseGenericFailure(
      exception.message ?? 'Firebase operation failed',
      code: exception.code,
      details: exception.message,
      originalError: exception,
    );
  }

  /// Detects regional restriction errors (like 403 Forbidden in Iran)
  static bool _isRegionalRestrictionError(dynamic exception) {
    if (exception is String) {
      return exception.contains('403') ||
          exception.contains('Forbidden') ||
          exception.contains('<!DOCTYPE html>') ||
          exception.contains('Error 403') ||
          exception.contains('Your client does not have permission');
    }

    if (exception is FirebaseException) {
      return exception.code == 'permission-denied' ||
          exception.message?.contains('403') == true ||
          exception.message?.contains('Forbidden') == true;
    }

    return false;
  }

  /// Handles regional restriction errors
  static FirebaseRegionalFailure _handleRegionalRestriction(
    dynamic exception,
    String? context,
  ) {
    print('🔥 [FIREBASE_ERROR] Regional restriction detected');

    String restrictionType = 'general';
    if (context?.contains('auth') == true) {
      restrictionType = 'authentication';
    } else if (context?.contains('firestore') == true) {
      restrictionType = 'firestore';
    } else if (context?.contains('network') == true) {
      restrictionType = 'network';
    }

    return FirebaseRegionalFailure.forRegion(
      'Iran', // Default region, can be made dynamic
      restrictionType,
      exception.toString(),
    );
  }

  /// Detects network-related errors
  static bool _isNetworkError(dynamic exception) {
    if (exception is String) {
      return exception.contains('network') ||
          exception.contains('connection') ||
          exception.contains('timeout') ||
          exception.contains('unreachable') ||
          exception.contains('failed to connect') ||
          exception.contains('Rst Stream') ||
          exception.contains('INTERNAL') ||
          exception.contains('Stream closed');
    }

    if (exception is FirebaseException) {
      return exception.code == 'unavailable' ||
          exception.code == 'deadline-exceeded' ||
          exception.code == 'internal' ||
          exception.message?.contains('network') == true ||
          exception.message?.contains('connection') == true ||
          exception.message?.contains('Rst Stream') == true ||
          exception.message?.contains('Stream closed') == true;
    }

    return false;
  }

  /// Handles network errors
  static FirebaseNetworkFailure _handleNetworkError(
    dynamic exception,
    String? context,
  ) {
    print('🔥 [FIREBASE_ERROR] Network error detected');

    int? statusCode;
    if (exception is String) {
      // Try to extract status code from error message
      final statusMatch = RegExp(r'(\d{3})').firstMatch(exception);
      if (statusMatch != null) {
        statusCode = int.tryParse(statusMatch.group(1)!);
      }
    }

    return FirebaseNetworkFailure.forNetworkError(
      exception.toString(),
      statusCode,
    );
  }

  /// Handles generic Firebase errors
  static FirebaseGenericFailure _handleGenericError(
    dynamic exception,
    String? context,
  ) {
    print('🔥 [FIREBASE_ERROR] Generic error: ${exception.runtimeType}');

    return FirebaseGenericFailure(
      exception.toString(),
      details: context != null ? 'Context: $context' : null,
      originalError: exception,
    );
  }

  /// Wraps a Firebase operation with error handling and timeout protection
  /// This is a convenience method for wrapping Firebase calls
  ///
  /// Parameters:
  /// - operation: The Firebase operation to execute
  /// - context: Optional context for better error classification
  /// - timeout: Timeout duration in seconds (default: 30 seconds)
  ///
  /// Returns: Either FirebaseFailure or the operation result
  static Future<T> wrapFirebaseOperation<T>(
    Future<T> Function() operation, {
    String? context,
    int timeoutSeconds = 30,
  }) async {
    try {
      // Add timeout protection to prevent hanging operations
      return await operation().timeout(
        Duration(seconds: timeoutSeconds),
        onTimeout: () {
          throw FirebaseNetworkFailure.forNetworkError(
            'Operation timed out after ${timeoutSeconds} seconds',
            null,
          );
        },
      );
    } catch (exception) {
      final failure = handleException(exception, context: context);
      throw failure;
    }
  }

  /// Checks if an error is recoverable
  static bool isRecoverable(dynamic exception) {
    final failure = handleException(exception);
    return failure.isRecoverable;
  }

  /// Checks if an error requires user action
  static bool requiresUserAction(dynamic exception) {
    final failure = handleException(exception);
    return failure.requiresUserAction;
  }

  /// Gets user-friendly error message
  static String getUserFriendlyMessage(dynamic exception) {
    final failure = handleException(exception);
    return failure.userFriendlyMessage;
  }

  /// Detects if an operation is hanging (like the INTERNAL errors you're seeing)
  /// This helps identify operations that are stuck in retry loops
  static bool isHangingOperation(dynamic exception) {
    if (exception is String) {
      return exception.contains('INTERNAL') ||
          exception.contains('Rst Stream') ||
          exception.contains('Stream closed') ||
          exception.contains('WriteStream') ||
          exception.contains('status=INTERNAL');
    }

    if (exception is FirebaseException) {
      return exception.code == 'internal' ||
          exception.message?.contains('Rst Stream') == true ||
          exception.message?.contains('Stream closed') == true ||
          exception.message?.contains('WriteStream') == true;
    }

    return false;
  }

  /// Creates a hanging operation failure
  static FirebaseNetworkFailure createHangingOperationFailure(String context) {
    return FirebaseNetworkFailure.forNetworkError(
      'Firebase operation is taking too long. This might be due to network issues or regional restrictions. Please try again later.',
      null,
    );
  }

  /// Logs error details for debugging
  static void logError(dynamic exception, {String? context}) {
    final failure = handleException(exception, context: context);

    print('🔥 [FIREBASE_ERROR] ===== ERROR LOG =====');
    print('🔥 [FIREBASE_ERROR] Context: $context');
    print('🔥 [FIREBASE_ERROR] Failure Type: ${failure.runtimeType}');
    print('🔥 [FIREBASE_ERROR] Message: ${failure.message}');
    print('🔥 [FIREBASE_ERROR] Code: ${failure.code}');
    print('🔥 [FIREBASE_ERROR] Details: ${failure.details}');
    print('🔥 [FIREBASE_ERROR] User Friendly: ${failure.userFriendlyMessage}');
    print('🔥 [FIREBASE_ERROR] Is Recoverable: ${failure.isRecoverable}');
    print(
      '🔥 [FIREBASE_ERROR] Requires User Action: ${failure.requiresUserAction}',
    );
    print('🔥 [FIREBASE_ERROR] ======================');
  }
}
