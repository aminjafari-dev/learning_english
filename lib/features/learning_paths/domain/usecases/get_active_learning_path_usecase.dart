// get_active_learning_path_usecase.dart
// Use case for retrieving the active learning path
// Handles the business logic for getting the current learning path

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/learning_path.dart';
import '../repositories/learning_paths_repository.dart';

/// Use case for getting the active learning path
/// Handles the business logic for retrieving the current learning path
class GetActiveLearningPathUseCase {
  final LearningPathsRepository _repository;

  /// Constructor
  /// @param repository Learning paths repository
  GetActiveLearningPathUseCase({required LearningPathsRepository repository})
    : _repository = repository;

  /// Gets the active learning path
  /// @return Either Failure or the active LearningPath (null if none exists)
  Future<Either<Failure, LearningPath?>> call() async {
    return await _repository.getActiveLearningPath();
  }
}
