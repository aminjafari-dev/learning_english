// delete_learning_path_by_id_usecase.dart
// Use case for deleting a specific learning path by ID
// Handles the business logic for removing a learning path

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/learning_paths_repository.dart';

/// Use case for deleting a learning path by ID
/// Handles the business logic for removing a specific learning path
class DeleteLearningPathByIdUseCase {
  final LearningPathsRepository _repository;

  /// Constructor
  /// @param repository Learning paths repository
  DeleteLearningPathByIdUseCase({required LearningPathsRepository repository})
    : _repository = repository;

  /// Deletes a learning path by ID
  /// @param pathId The ID of the learning path to delete
  /// @return Either Failure or void
  Future<Either<Failure, void>> call(String pathId) async {
    // Validate path ID
    if (pathId.isEmpty) {
      return left(ValidationFailure('Path ID cannot be empty'));
    }

    return await _repository.deleteLearningPath(pathId);
  }
}

