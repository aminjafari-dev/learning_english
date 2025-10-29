// get_learning_path_by_id_usecase.dart
// Use case for retrieving a specific learning path by ID
// Handles the business logic for getting a single learning path

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/learning_path.dart';
import '../repositories/learning_path_detail_repository.dart';

/// Use case for getting a learning path by ID
/// Handles the business logic for retrieving a specific learning path
class GetLearningPathByIdUseCase {
  final LearningPathDetailRepository _repository;

  /// Constructor
  /// @param repository Learning path detail repository
  GetLearningPathByIdUseCase({required LearningPathDetailRepository repository})
    : _repository = repository;

  /// Gets a learning path by ID
  /// @param pathId The ID of the learning path to retrieve
  /// @return Either Failure or the LearningPath (null if not found)
  Future<Either<Failure, LearningPath?>> call(String pathId) async {
    // Validate path ID
    if (pathId.isEmpty) {
      return left(ValidationFailure('Path ID cannot be empty'));
    }

    return await _repository.getLearningPathById(pathId);
  }
}
