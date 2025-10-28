// learning_paths_repository.dart
// Domain repository interface for learning paths
// Defines the contract for learning path operations

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/learning_path.dart';
import '../entities/sub_category.dart';
import '../../../level_selection/domain/entities/user_profile.dart';

/// Repository interface for learning paths operations
/// Defines the contract for learning path management
abstract class LearningPathsRepository {
  /// Creates a new learning path with the specified parameters
  /// @param level User's English proficiency level
  /// @param focusAreas List of focus areas for learning
  /// @param subCategory Selected sub-category for the learning path
  /// @return Either Failure or the created LearningPath
  Future<Either<Failure, LearningPath>> createLearningPath({
    required Level level,
    required List<String> focusAreas,
    required SubCategory subCategory,
  });

  /// Gets all learning paths
  /// @return Either Failure or List of all LearningPaths
  Future<Either<Failure, List<LearningPath>>> getAllLearningPaths();

  /// Gets a specific learning path by ID
  /// @param pathId The ID of the learning path to retrieve
  /// @return Either Failure or the LearningPath (null if not found)
  Future<Either<Failure, LearningPath?>> getLearningPathById(String pathId);

  /// Gets the active learning path (for backward compatibility)
  /// @return Either Failure or the active LearningPath (null if none exists)
  Future<Either<Failure, LearningPath?>> getActiveLearningPath();

  /// Marks a course as completed and unlocks the next course
  /// @param pathId The ID of the learning path
  /// @param courseNumber The course number to mark as completed
  /// @return Either Failure or void
  Future<Either<Failure, void>> completeCourse(String pathId, int courseNumber);

  /// Deletes a specific learning path by ID
  /// @param pathId The ID of the learning path to delete
  /// @return Either Failure or void
  Future<Either<Failure, void>> deleteLearningPath(String pathId);

  /// Checks if there are any learning paths
  /// @return Either Failure or boolean indicating if paths exist
  Future<Either<Failure, bool>> hasLearningPaths();

  /// Checks if there's an active learning path (for backward compatibility)
  /// @return Either Failure or boolean indicating if active path exists
  Future<Either<Failure, bool>> hasActiveLearningPath();

  /// Gets progress statistics for a specific learning path
  /// @param pathId The ID of the learning path
  /// @return Either Failure or Map with progress statistics
  Future<Either<Failure, Map<String, int>?>> getProgressStatistics(
    String pathId,
  );
}
