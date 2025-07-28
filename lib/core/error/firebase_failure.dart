// firebase_failure.dart
// Firebase-specific failure classes for comprehensive error handling.
// This file defines specific failure types for different Firebase errors
// including authentication, Firestore, regional restrictions, and network issues.

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';

/// Base Firebase failure class
/// All Firebase-specific failures extend this class
abstract class FirebaseFailure extends Equatable {
  final String message;
  final String? code;
  final String? details;
  final dynamic originalError;

  const FirebaseFailure(
    this.message, {
    this.code,
    this.details,
    this.originalError,
  });

  @override
  List<Object?> get props => [message, code, details, originalError];

  /// Returns a user-friendly error message
  String get userFriendlyMessage;

  /// Returns whether this error is recoverable
  bool get isRecoverable;

  /// Returns whether this error requires user action
  bool get requiresUserAction;
}

/// Authentication-related Firebase failures
class FirebaseAuthFailure extends FirebaseFailure {
  final fb_auth.FirebaseAuthException? authException;

  const FirebaseAuthFailure(
    String message, {
    String? code,
    String? details,
    dynamic originalError,
    this.authException,
  }) : super(
         message,
         code: code,
         details: details,
         originalError: originalError,
       );

  @override
  String get userFriendlyMessage {
    if (authException != null) {
      switch (authException!.code) {
        case 'user-not-found':
          return 'User account not found. Please sign in again.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'email-already-in-use':
          return 'This email is already registered. Please use a different email.';
        case 'weak-password':
          return 'Password is too weak. Please choose a stronger password.';
        case 'invalid-email':
          return 'Invalid email address. Please check your email format.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'too-many-requests':
          return 'Too many failed attempts. Please try again later.';
        case 'operation-not-allowed':
          return 'This operation is not allowed. Please try a different method.';
        case 'network-request-failed':
          return 'Network connection failed. Please check your internet connection.';
        case 'popup-closed-by-user':
          return 'Sign-in was cancelled. Please try again.';
        case 'popup-blocked':
          return 'Sign-in popup was blocked. Please allow popups and try again.';
        case 'account-exists-with-different-credential':
          return 'An account already exists with this email using a different sign-in method.';
        case 'invalid-credential':
          return 'Invalid credentials. Please check your sign-in information.';
        case 'operation-not-allowed':
          return 'This sign-in method is not enabled. Please contact support.';
        case 'user-token-expired':
          return 'Your session has expired. Please sign in again.';
        case 'user-token-revoked':
          return 'Your session has been revoked. Please sign in again.';
        case 'invalid-user-token':
          return 'Invalid session. Please sign in again.';
        case 'invalid-tenant-id':
          return 'Invalid tenant configuration. Please contact support.';
        case 'unsupported-persistence-type':
          return 'Unsupported persistence type. Please contact support.';
        case 'invalid-api-key':
          return 'Invalid API configuration. Please contact support.';
        case 'app-not-authorized':
          return 'App not authorized. Please contact support.';
        case 'quota-exceeded':
          return 'Service quota exceeded. Please try again later.';
        case 'keychain-error':
          return 'Keychain error. Please try again.';
        case 'internal-error':
          return 'Internal authentication error. Please try again.';
        case 'invalid-app-credential':
          return 'Invalid app credentials. Please contact support.';
        case 'invalid-verification-code':
          return 'Invalid verification code. Please check and try again.';
        case 'invalid-verification-id':
          return 'Invalid verification ID. Please try again.';
        case 'session-expired':
          return 'Session expired. Please sign in again.';
        case 'missing-verification-code':
          return 'Verification code is missing. Please try again.';
        case 'missing-verification-id':
          return 'Verification ID is missing. Please try again.';
        case 'credential-already-in-use':
          return 'This credential is already associated with another account.';
        case 'timeout':
          return 'Authentication timed out. Please try again.';
        case 'cancelled-popup-request':
          return 'Sign-in was cancelled. Please try again.';
        case 'network-request-failed':
          return 'Network connection failed. Please check your internet connection.';
        default:
          return 'Authentication failed. Please try again.';
      }
    }
    return message;
  }

  @override
  bool get isRecoverable {
    if (authException != null) {
      final nonRecoverableCodes = [
        'user-disabled',
        'invalid-api-key',
        'app-not-authorized',
        'quota-exceeded',
        'invalid-tenant-id',
        'unsupported-persistence-type',
      ];
      return !nonRecoverableCodes.contains(authException!.code);
    }
    return true;
  }

  @override
  bool get requiresUserAction {
    if (authException != null) {
      final userActionCodes = [
        'user-not-found',
        'wrong-password',
        'email-already-in-use',
        'weak-password',
        'invalid-email',
        'popup-closed-by-user',
        'popup-blocked',
        'account-exists-with-different-credential',
        'invalid-credential',
        'invalid-verification-code',
        'missing-verification-code',
        'missing-verification-id',
        'credential-already-in-use',
      ];
      return userActionCodes.contains(authException!.code);
    }
    return false;
  }

  /// Creates FirebaseAuthFailure from FirebaseAuthException
  factory FirebaseAuthFailure.fromException(
    fb_auth.FirebaseAuthException exception,
  ) {
    return FirebaseAuthFailure(
      exception.message ?? 'Authentication failed',
      code: exception.code,
      details: exception.message,
      originalError: exception,
      authException: exception,
    );
  }
}

/// Firestore-related Firebase failures
class FirebaseFirestoreFailure extends FirebaseFailure {
  final FirebaseException? firestoreException;

  const FirebaseFirestoreFailure(
    String message, {
    String? code,
    String? details,
    dynamic originalError,
    this.firestoreException,
  }) : super(
         message,
         code: code,
         details: details,
         originalError: originalError,
       );

  @override
  String get userFriendlyMessage {
    if (firestoreException != null) {
      switch (firestoreException!.code) {
        case 'permission-denied':
          return 'Access denied. You don\'t have permission to perform this action.';
        case 'unauthenticated':
          return 'You need to sign in to perform this action.';
        case 'not-found':
          return 'The requested data was not found.';
        case 'already-exists':
          return 'The data already exists.';
        case 'resource-exhausted':
          return 'Service quota exceeded. Please try again later.';
        case 'failed-precondition':
          return 'Operation failed due to a precondition not being met.';
        case 'aborted':
          return 'Operation was aborted. Please try again.';
        case 'out-of-range':
          return 'Operation is out of valid range.';
        case 'unimplemented':
          return 'This operation is not implemented.';
        case 'internal':
          return 'Internal server error. Please try again later.';
        case 'unavailable':
          return 'Service is temporarily unavailable. Please try again later.';
        case 'data-loss':
          return 'Data loss occurred. Please try again.';
        case 'deadline-exceeded':
          return 'Operation timed out. Please try again.';
        case 'cancelled':
          return 'Operation was cancelled.';
        case 'invalid-argument':
          return 'Invalid argument provided.';
        case 'unavailable':
          return 'Service is temporarily unavailable. Please try again later.';
        default:
          return 'Database operation failed. Please try again.';
      }
    }
    return message;
  }

  @override
  bool get isRecoverable {
    if (firestoreException != null) {
      final nonRecoverableCodes = [
        'permission-denied',
        'unauthenticated',
        'not-found',
        'already-exists',
        'resource-exhausted',
        'failed-precondition',
        'unimplemented',
        'data-loss',
        'invalid-argument',
      ];
      return !nonRecoverableCodes.contains(firestoreException!.code);
    }
    return true;
  }

  @override
  bool get requiresUserAction {
    if (firestoreException != null) {
      final userActionCodes = [
        'permission-denied',
        'unauthenticated',
        'not-found',
        'already-exists',
        'failed-precondition',
        'invalid-argument',
      ];
      return userActionCodes.contains(firestoreException!.code);
    }
    return false;
  }

  /// Creates FirebaseFirestoreFailure from FirebaseException
  factory FirebaseFirestoreFailure.fromException(FirebaseException exception) {
    return FirebaseFirestoreFailure(
      exception.message ?? 'Firestore operation failed',
      code: exception.code,
      details: exception.message,
      originalError: exception,
      firestoreException: exception,
    );
  }
}

/// Regional restriction failures (for Iran and other restricted regions)
class FirebaseRegionalFailure extends FirebaseFailure {
  final String? region;
  final String? restrictionType;

  const FirebaseRegionalFailure(
    String message, {
    String? code,
    String? details,
    dynamic originalError,
    this.region,
    this.restrictionType,
  }) : super(
         message,
         code: code,
         details: details,
         originalError: originalError,
       );

  @override
  String get userFriendlyMessage {
    if (restrictionType == 'network') {
      return 'Network access to Firebase services is restricted in your region. Please try using a VPN or contact support.';
    } else if (restrictionType == 'authentication') {
      return 'Authentication services are restricted in your region. Please try using a VPN or contact support.';
    } else if (restrictionType == 'firestore') {
      return 'Database services are restricted in your region. Please try using a VPN or contact support.';
    }
    return 'Firebase services are restricted in your region. Please try using a VPN or contact support.';
  }

  @override
  bool get isRecoverable => false;

  @override
  bool get requiresUserAction => true;

  /// Creates FirebaseRegionalFailure for specific regional issues
  factory FirebaseRegionalFailure.forRegion(
    String region,
    String restrictionType,
    String originalError,
  ) {
    return FirebaseRegionalFailure(
      'Firebase services restricted in $region',
      code: 'regional-restriction',
      details: originalError,
      originalError: originalError,
      region: region,
      restrictionType: restrictionType,
    );
  }
}

/// Network-related Firebase failures
class FirebaseNetworkFailure extends FirebaseFailure {
  final String? networkType;
  final int? statusCode;

  const FirebaseNetworkFailure(
    String message, {
    String? code,
    String? details,
    dynamic originalError,
    this.networkType,
    this.statusCode,
  }) : super(
         message,
         code: code,
         details: details,
         originalError: originalError,
       );

  @override
  String get userFriendlyMessage {
    if (statusCode != null) {
      switch (statusCode) {
        case 403:
          return 'Access forbidden. Please check your internet connection and try again.';
        case 404:
          return 'Service not found. Please try again later.';
        case 500:
          return 'Server error. Please try again later.';
        case 502:
          return 'Bad gateway. Please try again later.';
        case 503:
          return 'Service unavailable. Please try again later.';
        case 504:
          return 'Gateway timeout. Please try again later.';
        default:
          return 'Network error occurred. Please check your connection and try again.';
      }
    }
    return 'Network connection failed. Please check your internet connection and try again.';
  }

  @override
  bool get isRecoverable => true;

  @override
  bool get requiresUserAction => false;

  /// Creates FirebaseNetworkFailure for network issues
  factory FirebaseNetworkFailure.forNetworkError(
    String error,
    int? statusCode,
  ) {
    return FirebaseNetworkFailure(
      'Network error: $error',
      code: 'network-error',
      details: error,
      originalError: error,
      statusCode: statusCode,
    );
  }
}

/// Generic Firebase failure for unclassified errors
class FirebaseGenericFailure extends FirebaseFailure {
  const FirebaseGenericFailure(
    String message, {
    String? code,
    String? details,
    dynamic originalError,
  }) : super(
         message,
         code: code,
         details: details,
         originalError: originalError,
       );

  @override
  String get userFriendlyMessage =>
      'An unexpected error occurred. Please try again.';

  @override
  bool get isRecoverable => true;

  @override
  bool get requiresUserAction => false;
}
