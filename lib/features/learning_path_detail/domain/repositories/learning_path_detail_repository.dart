// learning_path_detail_repository.dart
// Domain repository interface for learning path detail operations
// Defines the contract for learning path detail management

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/learning_path.dart';

/// Repository interface for learning path detail operations
/// Defines the contract for learning path detail management
abstract class LearningPathDetailRepository {
  /// Gets a specific learning path by ID
  /// @param pathId The ID of the learning path to retrieve
  /// @return Either Failure or the LearningPath (null if not found)
  Future<Either<Failure, LearningPath?>> getLearningPathById(String pathId);

  /// Marks a course as completed and unlocks the next course
  /// @param pathId The ID of the learning path
  /// @param courseNumber The course number to mark as completed
  /// @return Either Failure or void
  Future<Either<Failure, void>> completeCourse(String pathId, int courseNumber);

  /// Deletes a specific learning path by ID
  /// @param pathId The ID of the learning path to delete
  /// @return Either Failure or void
  Future<Either<Failure, void>> deleteLearningPath(String pathId);

  /// Gets progress statistics for a specific learning path
  /// @param pathId The ID of the learning path
  /// @return Either Failure or Map with progress statistics
  Future<Either<Failure, Map<String, int>?>> getProgressStatistics(
    String pathId,
  );
}
