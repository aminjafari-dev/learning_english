// This file defines the UserRemoteDataSource for saving user level to Firestore.
// Usage: Called by the repository to persist the selected level.
// Example:
//   await dataSource.saveUserLevel('user123', Level.beginner);
//   final level = await dataSource.getUserLevel('user123');

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning_english/core/error/firebase_error_handler.dart';
import 'package:learning_english/core/error/firebase_failure.dart';
import '../../domain/entities/user_profile.dart';

class UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSource(this.firestore);

  /// Saves the user's selected English level to Firestore
  /// This method now includes comprehensive Firebase error handling
  /// for regional restrictions, network issues, and other Firebase errors
  Future<void> saveUserLevel(String userId, Level level) async {
    try {
      // Use a shorter timeout to prevent hanging operations
      await FirebaseErrorHandler.wrapFirebaseOperation(
        () async {
          await firestore.collection('users').doc(userId).set({
            'level': level.name,
          }, SetOptions(merge: true));
        },
        context: 'save_user_level',
        timeoutSeconds: 15, // Shorter timeout for better UX
      );
    } catch (exception) {
      // Log the error for debugging
      FirebaseErrorHandler.logError(exception, context: 'save_user_level');

      // Check if this is a hanging operation (like the INTERNAL errors you're seeing)
      if (FirebaseErrorHandler.isHangingOperation(exception)) {
        throw FirebaseErrorHandler.createHangingOperationFailure(
          'save_user_level',
        );
      }

      // Re-throw the exception (now a FirebaseFailure) for repository handling
      rethrow;
    }
  }

  /// Gets the user's selected English level from Firestore
  /// Returns the user's level or null if not found
  Future<Level?> getUserLevel(String userId) async {
    try {
      // Use a shorter timeout to prevent hanging operations
      final doc = await FirebaseErrorHandler.wrapFirebaseOperation(
        () async {
          return await firestore.collection('users').doc(userId).get();
        },
        context: 'get_user_level',
        timeoutSeconds: 15, // Shorter timeout for better UX
      );

      if (!doc.exists) {
        return null; // User document doesn't exist
      }

      final data = doc.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('level')) {
        return null; // No level field in document
      }

      final levelString = data['level'] as String;

      // Convert string to Level enum
      switch (levelString.toLowerCase()) {
        case 'beginner':
          return Level.beginner;
        case 'elementary':
          return Level.elementary;
        case 'intermediate':
          return Level.intermediate;
        case 'advanced':
          return Level.advanced;
        default:
          return null; // Invalid level string
      }
    } catch (exception) {
      // Log the error for debugging
      FirebaseErrorHandler.logError(exception, context: 'get_user_level');

      // Check if this is a hanging operation
      if (FirebaseErrorHandler.isHangingOperation(exception)) {
        throw FirebaseErrorHandler.createHangingOperationFailure(
          'get_user_level',
        );
      }

      // Re-throw the exception for repository handling
      rethrow;
    }
  }
}
