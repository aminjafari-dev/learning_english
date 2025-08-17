// auth_service.dart
// Centralized authentication service for managing user authentication state and operations.
//
// Usage Example:
//   final authService = getIt<AuthService>();
//   final isAuthenticated = await authService.isAuthenticated();
//   final currentUser = await authService.getCurrentUser();
//
// This service provides a single point of access for all authentication operations
// and ensures consistent authentication state across the app.

import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:learning_english/features/authentication/domain/entities/user.dart';
import 'package:learning_english/features/authentication/data/models/user_model.dart';

/// Centralized authentication service that manages user authentication state
/// Provides methods for checking authentication status, getting current user,
/// and handling authentication state changes
class AuthService {
  final SupabaseClient _supabaseClient;

  /// Constructor that injects Supabase client
  /// @param supabaseClient The Supabase client instance for authentication operations
  AuthService({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  /// Checks if the user is currently authenticated
  /// Returns true if user has a valid session, false otherwise
  /// This is useful for protecting routes and database operations
  Future<bool> isAuthenticated() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      return user != null;
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
      final user = _supabaseClient.auth.currentUser;
      if (user != null) {
        return UserModel.fromSupabaseUser(user).toEntity();
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
      return _supabaseClient.auth.currentUser?.id;
    } catch (e) {
      print('Error getting current user ID: $e');
      return null;
    }
  }

  /// Gets the current user's session
  /// Returns Session if authenticated, null otherwise
  /// This provides access to session tokens and metadata
  Session? getCurrentSession() {
    try {
      return _supabaseClient.auth.currentSession;
    } catch (e) {
      print('Error getting current session: $e');
      return null;
    }
  }

  /// Signs out the current user
  /// Clears the session and authentication state
  /// This should be called when user wants to logout
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      print('Error during sign out: $e');
      rethrow;
    }
  }

  /// Stream of authentication state changes
  /// This can be used to react to sign-in/sign-out events in real-time
  /// Useful for updating UI when authentication state changes
  Stream<User?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      if (user != null) {
        return UserModel.fromSupabaseUser(user).toEntity();
      }
      return null;
    });
  }

  /// Checks if the current session is valid and not expired
  /// Returns true if session is valid, false otherwise
  /// This is useful for validating session before making API calls
  bool isSessionValid() {
    try {
      final session = _supabaseClient.auth.currentSession;
      if (session == null) return false;

      // Check if session is not expired
      final now = DateTime.now();
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(
        (session.expiresAt ?? 0) * 1000,
      );

      return now.isBefore(expiresAt);
    } catch (e) {
      print('Error checking session validity: $e');
      return false;
    }
  }

  /// Refreshes the current session if needed
  /// This ensures the session is valid before making authenticated requests
  /// Should be called before important operations that require authentication
  Future<bool> refreshSessionIfNeeded() async {
    try {
      final session = _supabaseClient.auth.currentSession;
      if (session == null) return false;

      // Check if session expires within the next 5 minutes
      final now = DateTime.now();
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(
        (session.expiresAt ?? 0) * 1000,
      );
      final fiveMinutesFromNow = now.add(const Duration(minutes: 5));

      if (expiresAt.isBefore(fiveMinutesFromNow)) {
        await _supabaseClient.auth.refreshSession();
        return true;
      }

      return true;
    } catch (e) {
      print('Error refreshing session: $e');
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
