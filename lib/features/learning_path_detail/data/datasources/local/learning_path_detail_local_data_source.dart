// learning_path_detail_local_data_source.dart
// Local data source for learning path detail using Hive storage
// Handles operations specific to learning path detail page

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/learning_path_model.dart';
import '../../../domain/entities/learning_path.dart';

/// Local data source for learning path detail using Hive storage
/// Handles operations specific to learning path detail page
class LearningPathDetailLocalDataSource {
  static const String _boxName = 'learning_paths';
  static const String _pathsListKey = 'learning_paths_list';

  Box? _box;

  /// Constructor
  LearningPathDetailLocalDataSource();

  /// Initialize the data source and open Hive box
  Future<void> initialize() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(_boxName);
      print('✅ [LEARNING_PATH_DETAIL] Hive box initialized: $_boxName');
    }
  }

  /// Gets a specific learning path by ID
  /// @param pathId The ID of the learning path to retrieve
  /// @return The learning path or null if not found
  Future<LearningPath?> getLearningPathById(String pathId) async {
    try {
      await initialize();

      // Get all learning paths
      final allPaths = await getAllLearningPaths();
      return allPaths.firstWhere(
        (path) => path.id == pathId,
        orElse: () => throw Exception('Learning path not found'),
      );
    } catch (exception) {
      print(
        '❌ [LEARNING_PATH_DETAIL] Error getting learning path by ID: $exception',
      );
      return null;
    }
  }

  /// Gets all learning paths
  /// Returns a list of all saved learning paths
  /// @return List of all learning paths
  Future<List<LearningPath>> getAllLearningPaths() async {
    try {
      await initialize();

      // Get the raw data from Hive and safely cast it
      final rawData = _box?.get(_pathsListKey);
      if (rawData == null) {
        print('✅ [LEARNING_PATH_DETAIL] Retrieved 0 learning paths (no data)');
        return [];
      }

      // Safely cast the list and convert each item to LearningPathModel
      final List<dynamic> rawList = rawData as List<dynamic>;
      final learningPathModels =
          rawList.map((item) => item as LearningPathModel).toList();

      // Convert models to entities
      final learningPaths =
          learningPathModels.map((model) => model.toEntity()).toList();

      print(
        '✅ [LEARNING_PATH_DETAIL] Retrieved ${learningPaths.length} learning paths',
      );
      return learningPaths;
    } catch (exception) {
      print(
        '❌ [LEARNING_PATH_DETAIL] Error getting all learning paths: $exception',
      );
      return [];
    }
  }

  /// Updates course progress for a specific course in a specific learning path
  /// @param pathId The ID of the learning path to update
  /// @param courseNumber The course number to update
  /// @param isCompleted Whether the course is completed
  /// @throws Exception when update operation fails
  Future<void> updateCourseProgress(
    String pathId,
    int courseNumber,
    bool isCompleted,
  ) async {
    try {
      await initialize();

      final allPaths = await getAllLearningPaths();
      final pathIndex = allPaths.indexWhere((path) => path.id == pathId);

      if (pathIndex == -1) {
        throw Exception('Learning path not found');
      }

      final learningPath = allPaths[pathIndex];

      // Find and update the specific course
      final updatedCourses =
          learningPath.courses.map((course) {
            if (course.courseNumber == courseNumber) {
              return course.copyWith(
                isCompleted: isCompleted,
                completionDate: isCompleted ? DateTime.now() : null,
              );
            }
            return course;
          }).toList();

      // Update the learning path with modified courses
      final updatedLearningPath = learningPath.copyWith(
        courses: updatedCourses,
        updatedAt: DateTime.now(),
      );

      // Update the path in the list
      allPaths[pathIndex] = updatedLearningPath;

      // Save the updated list
      final updatedModels =
          allPaths.map((path) => LearningPathModel.fromEntity(path)).toList();
      await _box?.put(_pathsListKey, updatedModels);

      print(
        '✅ [LEARNING_PATH_DETAIL] Course $courseNumber progress updated in path $pathId: completed=$isCompleted',
      );
    } catch (exception) {
      print(
        '❌ [LEARNING_PATH_DETAIL] Error updating course progress: $exception',
      );
      rethrow;
    }
  }

  /// Unlocks the next course in a specific learning path
  /// @param pathId The ID of the learning path to update
  /// @param courseNumber The course number to unlock
  /// @throws Exception when unlock operation fails
  Future<void> unlockCourse(String pathId, int courseNumber) async {
    try {
      await initialize();

      final allPaths = await getAllLearningPaths();
      final pathIndex = allPaths.indexWhere((path) => path.id == pathId);

      if (pathIndex == -1) {
        throw Exception('Learning path not found');
      }

      final learningPath = allPaths[pathIndex];

      // Find and unlock the specific course
      final updatedCourses =
          learningPath.courses.map((course) {
            if (course.courseNumber == courseNumber) {
              return course.copyWith(isUnlocked: true);
            }
            return course;
          }).toList();

      // Update the learning path with modified courses
      final updatedLearningPath = learningPath.copyWith(
        courses: updatedCourses,
        updatedAt: DateTime.now(),
      );

      // Update the path in the list
      allPaths[pathIndex] = updatedLearningPath;

      // Save the updated list
      final updatedModels =
          allPaths.map((path) => LearningPathModel.fromEntity(path)).toList();
      await _box?.put(_pathsListKey, updatedModels);

      print(
        '✅ [LEARNING_PATH_DETAIL] Course $courseNumber unlocked in path $pathId',
      );
    } catch (exception) {
      print('❌ [LEARNING_PATH_DETAIL] Error unlocking course: $exception');
      rethrow;
    }
  }

  /// Deletes a specific learning path by ID
  /// @param pathId The ID of the learning path to delete
  /// @throws Exception when delete operation fails
  Future<void> deleteLearningPath(String pathId) async {
    try {
      await initialize();

      final allPaths = await getAllLearningPaths();
      final updatedPaths = allPaths.where((path) => path.id != pathId).toList();

      // Save the updated list
      final updatedModels =
          updatedPaths
              .map((path) => LearningPathModel.fromEntity(path))
              .toList();
      await _box?.put(_pathsListKey, updatedModels);

      print('✅ [LEARNING_PATH_DETAIL] Learning path $pathId deleted');
    } catch (exception) {
      print(
        '❌ [LEARNING_PATH_DETAIL] Error deleting learning path: $exception',
      );
      rethrow;
    }
  }

  /// Gets the progress statistics for a specific learning path
  /// @param pathId The ID of the learning path to get statistics for
  /// @return Map with progress statistics or null if path not found
  Future<Map<String, int>?> getProgressStatistics(String pathId) async {
    try {
      final learningPath = await getLearningPathById(pathId);
      if (learningPath == null) {
        return null;
      }

      final completedCourses =
          learningPath.courses.where((course) => course.isCompleted).length;

      final totalCourses = learningPath.courses.length;
      final unlockedCourses =
          learningPath.courses.where((course) => course.isUnlocked).length;

      return {
        'completed': completedCourses,
        'total': totalCourses,
        'unlocked': unlockedCourses,
      };
    } catch (exception) {
      print(
        '❌ [LEARNING_PATH_DETAIL] Error getting progress statistics: $exception',
      );
      return null;
    }
  }

  /// Closes the Hive box
  Future<void> close() async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
      print('✅ [LEARNING_PATH_DETAIL] Hive box closed');
    }
  }
}
