// delete_learning_path_usecase.dart
// Use case for deleting the active learning path
// Handles the business logic for removing the current learning path

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/learning_paths_repository.dart';

/// Use case for deleting the active learning path
/// Handles the business logic for removing the current learning path
class DeleteLearningPathUseCase {
  final LearningPathsRepository _repository;

  /// Constructor
  /// @param repository Learning paths repository
  DeleteLearningPathUseCase({required LearningPathsRepository repository})
    : _repository = repository;

  /// Deletes the active learning path
  /// @return Either Failure or void
  Future<Either<Failure, void>> call() async {
    // Get the active learning path first
    final activePathResult = await _repository.getActiveLearningPath();
    return activePathResult.fold((failure) => left(failure), (
      activePath,
    ) async {
      if (activePath != null) {
        return await _repository.deleteLearningPath(activePath.id);
      } else {
        return left(ValidationFailure('No active learning path found'));
      }
    });
  }
}
