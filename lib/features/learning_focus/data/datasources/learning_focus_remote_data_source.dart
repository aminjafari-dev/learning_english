// learning_focus_remote_data_source.dart
// Remote data source for user learning focus preferences using Firestore.
//
// Usage Example:
//   final dataSource = LearningFocusRemoteDataSourceImpl(firestore);
//   await dataSource.saveUserLearningFocus(userFocusModel);
//
// This data source handles remote storage of user learning focus preferences.

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_learning_focus_model.dart';

abstract class LearningFocusRemoteDataSource {
  Future<void> saveUserLearningFocus(UserLearningFocusModel userLearningFocus);
  Future<UserLearningFocusModel?> getUserLearningFocus(String userId);
  Future<void> updateUserLearningFocus(UserLearningFocusModel userLearningFocus);
}

class LearningFocusRemoteDataSourceImpl implements LearningFocusRemoteDataSource {
  final FirebaseFirestore firestore;
  static const String collectionName = 'user_learning_focus';

  LearningFocusRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> saveUserLearningFocus(UserLearningFocusModel userLearningFocus) async {
    try {
      final modelWithTimestamp = userLearningFocus.withUpdatedTimestamp();
      await firestore
          .collection(collectionName)
          .doc(userLearningFocus.userId)
          .set(modelWithTimestamp.toJson());
    } catch (e) {
      throw Exception('Failed to save user learning focus: $e');
    }
  }

  @override
  Future<UserLearningFocusModel?> getUserLearningFocus(String userId) async {
    try {
      final doc = await firestore
          .collection(collectionName)
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        return UserLearningFocusModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user learning focus: $e');
    }
  }

  @override
  Future<void> updateUserLearningFocus(UserLearningFocusModel userLearningFocus) async {
    try {
      final modelWithTimestamp = userLearningFocus.withUpdatedTimestamp();
      await firestore
          .collection(collectionName)
          .doc(userLearningFocus.userId)
          .update(modelWithTimestamp.toJson());
    } catch (e) {
      throw Exception('Failed to update user learning focus: $e');
    }
  }
}
