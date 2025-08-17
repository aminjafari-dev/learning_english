// auth_middleware.dart
// Authentication middleware for protecting database operations.
//
// Usage Example:
//   final result = await AuthMiddleware.withAuth(() =>
//     repository.getUserData(userId)
//   );
//
// This middleware ensures all database operations are performed with proper authentication
// and can be easily integrated with existing repositories and data sources.

import 'package:learning_english/core/services/auth_service.dart';
import 'package:learning_english/features/authentication/domain/entities/user.dart';

/// Authentication middleware that wraps operations to ensure authentication
/// Provides a simple way to protect any database operation with authentication
class AuthMiddleware {
  static final AuthService _authService = AuthService();

  /// Executes an operation with authentication validation
  /// @param operation The operation to execute
  /// @return The result of the operation
  /// This method ensures the user is authenticated before allowing the operation
  static Future<T> withAuth<T>(Future<T> Function() operation) async {
    // Validate authentication before allowing the operation
    await _authService.validateAuthentication();

    // Refresh session if needed to ensure valid authentication
    await _authService.refreshSessionIfNeeded();

    try {
      return await operation();
    } catch (e) {
      if (e is UnauthorizedException) {
        rethrow;
      }
      throw DatabaseException('Operation failed: ${e.toString()}');
    }
  }

  /// Gets the current user's ID for use in operations
  /// @return The current user's ID or throws UnauthorizedException
  /// This is commonly used for filtering data by user
  static String getCurrentUserId() {
    final userId = _authService.getCurrentUserId();
    if (userId == null) {
      throw UnauthorizedException('User must be authenticated to access data');
    }
    return userId;
  }

  /// Checks if the user is currently authenticated
  /// @return true if user is authenticated, false otherwise
  /// This is useful for conditional operations
  static Future<bool> isAuthenticated() async {
    return await _authService.isAuthenticated();
  }

  /// Gets the current authenticated user
  /// @return User entity if authenticated, null otherwise
  /// This provides access to user data throughout the app
  static Future<User?> getCurrentUser() async {
    return await _authService.getCurrentUser();
  }

  /// Executes an operation only if the user is authenticated
  /// @param operation The operation to execute
  /// @param defaultValue The default value to return if not authenticated
  /// @return The result of the operation or the default value
  /// This method is useful for operations that can work with or without authentication
  static Future<T> withAuthOrDefault<T>(
    Future<T> Function() operation,
    T defaultValue,
  ) async {
    try {
      return await withAuth(operation);
    } catch (e) {
      if (e is UnauthorizedException) {
        return defaultValue;
      }
      rethrow;
    }
  }

  /// Executes an operation with user ID validation
  /// @param operation The operation to execute with user ID
  /// @return The result of the operation
  /// This method automatically provides the current user's ID to the operation
  static Future<T> withUserContext<T>(
    Future<T> Function(String userId) operation,
  ) async {
    return withAuth(() {
      final userId = getCurrentUserId();
      return operation(userId);
    });
  }

  /// Validates that a record belongs to the current user
  /// @param recordUserId The user ID associated with the record
  /// @return true if the record belongs to the current user, false otherwise
  /// This method is useful for validating ownership before operations
  static bool validateRecordOwnership(String recordUserId) {
    final currentUserId = getCurrentUserId();
    return recordUserId == currentUserId;
  }

  /// Executes an operation with record ownership validation
  /// @param recordUserId The user ID associated with the record
  /// @param operation The operation to execute
  /// @return The result of the operation
  /// This method ensures users can only access their own data
  static Future<T> withRecordOwnership<T>(
    String recordUserId,
    Future<T> Function() operation,
  ) async {
    if (!validateRecordOwnership(recordUserId)) {
      throw UnauthorizedException(
        'Access denied: Record does not belong to current user',
      );
    }

    return withAuth(operation);
  }
}

/// Exception thrown when database operations fail
/// This provides clear error handling for database failures
class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}
