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

  /// Gets the active learning path
  /// @return Either Failure or the active LearningPath (null if none exists)
  Future<Either<Failure, LearningPath?>> getActiveLearningPath();

  /// Marks a course as completed and unlocks the next course
  /// @param courseNumber The course number to mark as completed
  /// @return Either Failure or void
  Future<Either<Failure, void>> completeCourse(int courseNumber);

  /// Deletes the active learning path
  /// @return Either Failure or void
  Future<Either<Failure, void>> deleteLearningPath();

  /// Checks if there's an active learning path
  /// @return Either Failure or boolean indicating if active path exists
  Future<Either<Failure, bool>> hasActiveLearningPath();

  /// Gets progress statistics for the active learning path
  /// @return Either Failure or Map with progress statistics
  Future<Either<Failure, Map<String, int>?>> getProgressStatistics();
}
