// auth_service.dart
// Centralized authentication service for managing user authentication state and operations.
// This implementation uses local storage (Hive) for user authentication.
//
// Usage Example:
//   final authService = getIt<AuthService>();
//   final isAuthenticated = await authService.isAuthenticated();
//   final currentUser = await authService.getCurrentUser();
//
// This service provides a single point of access for all authentication operations
// and ensures consistent authentication state across the app.

import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_english/features/authentication/domain/entities/user.dart';
import 'package:learning_english/features/authentication/data/models/user_model.dart';

/// Centralized authentication service that manages user authentication state
/// Provides methods for checking authentication status, getting current user,
/// and handling authentication state changes using local Hive storage
class AuthService {
  static const String _authBoxName = 'auth_box';
  static const String _currentUserKey = 'current_user';

  Box? _authBox;

  /// Constructor
  AuthService();

  /// Initialize the auth service and open Hive box
  Future<void> initialize() async {
    if (_authBox == null || !_authBox!.isOpen) {
      _authBox = await Hive.openBox(_authBoxName);
    }
  }

  /// Checks if the user is currently authenticated
  /// Returns true if user has a valid session, false otherwise
  /// This is useful for protecting routes and database operations
  Future<bool> isAuthenticated() async {
    try {
      await initialize();
      final userMap = _authBox?.get(_currentUserKey);
      return userMap != null;
    } catch (e) {
      print('Error checking authentication status: $e');
      return false;
    }
  }

  /// Gets the current authenticated user
  /// Returns User entity if authenticated, null otherwise
  /// This provides access to user data throughout the app
  Future<User?> getCurrentUser() async {
    try {
      await initialize();
      final userMap = _authBox?.get(_currentUserKey);
      if (userMap != null && userMap is Map) {
        return UserModel.fromJson(
          Map<String, dynamic>.from(userMap),
        ).toEntity();
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  /// Gets the current user's ID
  /// Returns user ID if authenticated, null otherwise
  /// This is commonly used for database operations and API calls
  String? getCurrentUserId() {
    try {
      final userMap = _authBox?.get(_currentUserKey);
      if (userMap != null && userMap is Map) {
        return userMap['id'] as String?;
      }
      return null;
    } catch (e) {
      print('Error getting current user ID: $e');
      return null;
    }
  }

  /// Save user to local storage
  /// This method stores the user data in Hive for persistent authentication
  Future<void> saveUser(UserModel user) async {
    try {
      await initialize();
      await _authBox?.put(_currentUserKey, user.toJson());
    } catch (e) {
      print('Error saving user: $e');
      rethrow;
    }
  }

  /// Signs out the current user
  /// Clears the session and authentication state
  /// This should be called when user wants to logout
  Future<void> signOut() async {
    try {
      await initialize();
      await _authBox?.delete(_currentUserKey);
    } catch (e) {
      print('Error during sign out: $e');
      rethrow;
    }
  }

  /// Checks if the current session is valid and not expired
  /// Returns true if session is valid, false otherwise
  /// This is useful for validating session before making API calls
  bool isSessionValid() {
    try {
      // For local authentication, we just check if user exists
      // In a production app, you might want to add session expiry logic
      final userMap = _authBox?.get(_currentUserKey);
      return userMap != null;
    } catch (e) {
      print('Error checking session validity: $e');
      return false;
    }
  }

  /// Validates authentication before performing operations
  /// Throws UnauthorizedException if user is not authenticated
  /// This is a helper method for protecting operations that require authentication
  Future<void> validateAuthentication() async {
    if (!await isAuthenticated()) {
      throw UnauthorizedException(
        'User must be authenticated to perform this operation',
      );
    }

    if (!isSessionValid()) {
      throw UnauthorizedException('Session is invalid or expired');
    }
  }
}

/// Exception thrown when user is not authenticated
/// This provides clear error handling for authentication failures
class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);

  @override
  String toString() => 'UnauthorizedException: $message';
}
