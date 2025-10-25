// learning_paths_local_data_source.dart
// Local data source for learning paths using Hive storage
// Follows the existing pattern from user_profile_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/learning_path_model.dart';
import '../../../domain/entities/learning_path.dart';

/// Local data source for learning paths using Hive storage
/// Handles saving and retrieving learning paths and course progress
class LearningPathsLocalDataSource {
  static const String _boxName = 'learning_paths';
  static const String _activePathKey = 'active_learning_path';

  Box? _box;

  /// Constructor
  LearningPathsLocalDataSource();

  /// Initialize the data source and open Hive box
  Future<void> initialize() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(_boxName);
      print('✅ [LEARNING_PATHS] Hive box initialized: $_boxName');
    }
  }

  /// Saves a learning path as the active path
  /// Since we only allow one active path, this replaces any existing path
  /// @param learningPath The learning path to save
  /// @throws Exception when save operation fails
  Future<void> saveLearningPath(LearningPath learningPath) async {
    try {
      await initialize();

      final learningPathModel = LearningPathModel.fromEntity(learningPath);

      // Save as the active learning path
      await _box?.put(_activePathKey, learningPathModel);

      print('✅ [LEARNING_PATHS] Learning path saved: ${learningPath.title}');
    } catch (exception) {
      print('❌ [LEARNING_PATHS] Error saving learning path: $exception');
      rethrow;
    }
  }

  /// Gets the active learning path
  /// Returns the current active learning path or null if none exists
  /// @return The active learning path or null if not found
  Future<LearningPath?> getActiveLearningPath() async {
    try {
      await initialize();

      final learningPathModel = _box?.get(_activePathKey) as LearningPathModel?;

      if (learningPathModel != null) {
        final learningPath = learningPathModel.toEntity();
        print(
          '✅ [LEARNING_PATHS] Retrieved active learning path: ${learningPath.title}',
        );
        return learningPath;
      } else {
        print('ℹ️ [LEARNING_PATHS] No active learning path found');
        return null;
      }
    } catch (exception) {
      print(
        '❌ [LEARNING_PATHS] Error getting active learning path: $exception',
      );
      return null;
    }
  }

  /// Updates course progress for a specific course
  /// @param courseNumber The course number to update
  /// @param isCompleted Whether the course is completed
  /// @throws Exception when update operation fails
  Future<void> updateCourseProgress(int courseNumber, bool isCompleted) async {
    try {
      await initialize();

      final learningPathModel = _box?.get(_activePathKey) as LearningPathModel?;

      if (learningPathModel == null) {
        throw Exception('No active learning path found');
      }

      // Find and update the specific course
      final updatedCourses =
          learningPathModel.courses.map((course) {
            if (course.courseNumber == courseNumber) {
              return course.copyWith(
                isCompleted: isCompleted,
                completionDate:
                    isCompleted ? DateTime.now().toIso8601String() : null,
              );
            }
            return course;
          }).toList();

      // Update the learning path with modified courses
      final updatedLearningPath = learningPathModel.copyWith(
        courses: updatedCourses,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _box?.put(_activePathKey, updatedLearningPath);

      print(
        '✅ [LEARNING_PATHS] Course $courseNumber progress updated: completed=$isCompleted',
      );
    } catch (exception) {
      print('❌ [LEARNING_PATHS] Error updating course progress: $exception');
      rethrow;
    }
  }

  /// Unlocks the next course in the learning path
  /// @param courseNumber The course number to unlock
  /// @throws Exception when unlock operation fails
  Future<void> unlockCourse(int courseNumber) async {
    try {
      await initialize();

      final learningPathModel = _box?.get(_activePathKey) as LearningPathModel?;

      if (learningPathModel == null) {
        throw Exception('No active learning path found');
      }

      // Find and unlock the specific course
      final updatedCourses =
          learningPathModel.courses.map((course) {
            if (course.courseNumber == courseNumber) {
              return course.copyWith(isUnlocked: true);
            }
            return course;
          }).toList();

      // Update the learning path with modified courses
      final updatedLearningPath = learningPathModel.copyWith(
        courses: updatedCourses,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _box?.put(_activePathKey, updatedLearningPath);

      print('✅ [LEARNING_PATHS] Course $courseNumber unlocked');
    } catch (exception) {
      print('❌ [LEARNING_PATHS] Error unlocking course: $exception');
      rethrow;
    }
  }

  /// Deletes the active learning path
  /// @throws Exception when delete operation fails
  Future<void> deleteActiveLearningPath() async {
    try {
      await initialize();

      await _box?.delete(_activePathKey);

      print('✅ [LEARNING_PATHS] Active learning path deleted');
    } catch (exception) {
      print('❌ [LEARNING_PATHS] Error deleting learning path: $exception');
      rethrow;
    }
  }

  /// Checks if there's an active learning path
  /// @return True if there's an active learning path, false otherwise
  Future<bool> hasActiveLearningPath() async {
    try {
      await initialize();
      return _box?.containsKey(_activePathKey) ?? false;
    } catch (exception) {
      print(
        '❌ [LEARNING_PATHS] Error checking for active learning path: $exception',
      );
      return false;
    }
  }

  /// Gets the progress statistics for the active learning path
  /// @return Map with progress statistics or null if no active path
  Future<Map<String, int>?> getProgressStatistics() async {
    try {
      await initialize();

      final learningPathModel = _box?.get(_activePathKey) as LearningPathModel?;

      if (learningPathModel == null) {
        return null;
      }

      final completedCourses =
          learningPathModel.courses
              .where((course) => course.isCompleted)
              .length;

      final totalCourses = learningPathModel.courses.length;
      final unlockedCourses =
          learningPathModel.courses.where((course) => course.isUnlocked).length;

      return {
        'completed': completedCourses,
        'total': totalCourses,
        'unlocked': unlockedCourses,
      };
    } catch (exception) {
      print('❌ [LEARNING_PATHS] Error getting progress statistics: $exception');
      return null;
    }
  }

  /// Closes the Hive box
  Future<void> close() async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
      print('✅ [LEARNING_PATHS] Hive box closed');
    }
  }
}
