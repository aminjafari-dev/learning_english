// This file defines the UserRemoteDataSource for saving user level to Firestore.
// Usage: Called by the repository to persist the selected level.
// Example:
//   await dataSource.saveUserLevel('user123', Level.beginner);

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
}
