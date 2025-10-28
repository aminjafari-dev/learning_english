// learning_paths_local_data_source.dart
// Local data source for learning paths using Hive storage
// Follows the existing pattern from user_profile_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/learning_path_model.dart';
import '../../../domain/entities/learning_path.dart';

/// Local data source for learning paths using Hive storage
/// Handles saving and retrieving multiple learning paths and course progress
class LearningPathsLocalDataSource {
  static const String _boxName = 'learning_paths';
  static const String _pathsListKey = 'learning_paths_list';

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

  /// Saves a learning path to the list of paths
  /// Adds the new path to the existing list or creates a new list
  /// @param learningPath The learning path to save
  /// @throws Exception when save operation fails
  Future<void> saveLearningPath(LearningPath learningPath) async {
    try {
      await initialize();

      final learningPathModel = LearningPathModel.fromEntity(learningPath);

      // Get existing paths as models (not entities)
      final existingPaths = await _getAllLearningPathModels();

      // Add new path to the list
      final updatedPaths = [...existingPaths, learningPathModel];

      // Save the updated list
      await _box?.put(_pathsListKey, updatedPaths);

      print('✅ [LEARNING_PATHS] Learning path saved: ${learningPath.title}');
    } catch (exception) {
      print('❌ [LEARNING_PATHS] Error saving learning path: $exception');
      rethrow;
    }
  }

  /// Gets all learning path models from Hive storage
  /// Returns raw models without converting to entities
  /// @return List of LearningPathModel objects
  Future<List<LearningPathModel>> _getAllLearningPathModels() async {
    try {
      await initialize();

      // Get the raw data from Hive and safely cast it
      final rawData = _box?.get(_pathsListKey);
      if (rawData == null) {
        print('✅ [LEARNING_PATHS] Retrieved 0 learning path models (no data)');
        return [];
      }

      // Safely cast the list and convert each item to LearningPathModel
      final List<dynamic> rawList = rawData as List<dynamic>;
      final learningPathModels =
          rawList.map((item) => item as LearningPathModel).toList();

      print(
        '✅ [LEARNING_PATHS] Retrieved ${learningPathModels.length} learning path models',
      );
      return learningPathModels;
    } catch (exception) {
      print(
        '❌ [LEARNING_PATHS] Error getting all learning path models: $exception',
      );
      return [];
    }
  }

  /// Gets all learning paths
  /// Returns a list of all saved learning paths
  /// @return List of all learning paths
  Future<List<LearningPath>> getAllLearningPaths() async {
    try {
      // Get models from storage
      final learningPathModels = await _getAllLearningPathModels();

      // Convert models to entities
      final learningPaths =
          learningPathModels.map((model) => model.toEntity()).toList();

      print(
        '✅ [LEARNING_PATHS] Retrieved ${learningPaths.length} learning paths',
      );
      return learningPaths;
    } catch (exception) {
      print('❌ [LEARNING_PATHS] Error getting all learning paths: $exception');
      return [];
    }
  }

  /// Gets a specific learning path by ID
  /// @param pathId The ID of the learning path to retrieve
  /// @return The learning path or null if not found
  Future<LearningPath?> getLearningPathById(String pathId) async {
    try {
      final allPaths = await getAllLearningPaths();
      return allPaths.firstWhere(
        (path) => path.id == pathId,
        orElse: () => throw Exception('Learning path not found'),
      );
    } catch (exception) {
      print('❌ [LEARNING_PATHS] Error getting learning path by ID: $exception');
      return null;
    }
  }

  /// Gets the active learning path (for backward compatibility)
  /// Returns the most recently created learning path or null if none exists
  /// @return The most recent learning path or null if not found
  Future<LearningPath?> getActiveLearningPath() async {
    try {
      final allPaths = await getAllLearningPaths();
      if (allPaths.isEmpty) {
        print('ℹ️ [LEARNING_PATHS] No learning paths found');
        return null;
      }

      // Return the most recently created path
      allPaths.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final mostRecent = allPaths.first;

      print(
        '✅ [LEARNING_PATHS] Retrieved most recent learning path: ${mostRecent.title}',
      );
      return mostRecent;
    } catch (exception) {
      print(
        '❌ [LEARNING_PATHS] Error getting active learning path: $exception',
      );
      return null;
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
        '✅ [LEARNING_PATHS] Course $courseNumber progress updated in path $pathId: completed=$isCompleted',
      );
    } catch (exception) {
      print('❌ [LEARNING_PATHS] Error updating course progress: $exception');
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

      print('✅ [LEARNING_PATHS] Course $courseNumber unlocked in path $pathId');
    } catch (exception) {
      print('❌ [LEARNING_PATHS] Error unlocking course: $exception');
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

      print('✅ [LEARNING_PATHS] Learning path $pathId deleted');
    } catch (exception) {
      print('❌ [LEARNING_PATHS] Error deleting learning path: $exception');
      rethrow;
    }
  }

  /// Deletes the active learning path (for backward compatibility)
  /// @throws Exception when delete operation fails
  Future<void> deleteActiveLearningPath() async {
    try {
      final activePath = await getActiveLearningPath();
      if (activePath != null) {
        await deleteLearningPath(activePath.id);
      }
    } catch (exception) {
      print(
        '❌ [LEARNING_PATHS] Error deleting active learning path: $exception',
      );
      rethrow;
    }
  }

  /// Checks if there are any learning paths
  /// @return True if there are learning paths, false otherwise
  Future<bool> hasLearningPaths() async {
    try {
      final allPaths = await getAllLearningPaths();
      return allPaths.isNotEmpty;
    } catch (exception) {
      print('❌ [LEARNING_PATHS] Error checking for learning paths: $exception');
      return false;
    }
  }

  /// Checks if there's an active learning path (for backward compatibility)
  /// @return True if there's an active learning path, false otherwise
  Future<bool> hasActiveLearningPath() async {
    return await hasLearningPaths();
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
      print('❌ [LEARNING_PATHS] Error getting progress statistics: $exception');
      return null;
    }
  }

  /// Gets the progress statistics for the active learning path (for backward compatibility)
  /// @return Map with progress statistics or null if no active path
  Future<Map<String, int>?> getActiveProgressStatistics() async {
    try {
      final activePath = await getActiveLearningPath();
      if (activePath == null) {
        return null;
      }
      return await getProgressStatistics(activePath.id);
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
