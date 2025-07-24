// This file defines the UserRemoteDataSource for saving user level to Firestore.
// Usage: Called by the repository to persist the selected level.
// Example:
//   await dataSource.saveUserLevel('user123', Level.beginner);

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_profile.dart';

class UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSource(this.firestore);

  /// Saves the user's selected English level to Firestore
  Future<void> saveUserLevel(String userId, Level level) async {
    try {
      await firestore.collection('users').doc(userId).set({
        'level': level.name,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(
        'Failed to save user level to Firestore: ${e.toString()}',
      );
    }
  }
}
