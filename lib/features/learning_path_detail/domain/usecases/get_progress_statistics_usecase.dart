// get_progress_statistics_usecase.dart
// Use case for retrieving progress statistics for a learning path
// Handles the business logic for getting progress data

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/learning_path_detail_repository.dart';

/// Use case for getting progress statistics
/// Handles the business logic for retrieving progress data
class GetProgressStatisticsUseCase {
  final LearningPathDetailRepository _repository;

  /// Constructor
  /// @param repository Learning path detail repository
  GetProgressStatisticsUseCase({
    required LearningPathDetailRepository repository,
  }) : _repository = repository;

  /// Gets progress statistics for a learning path
  /// @param pathId The ID of the learning path
  /// @return Either Failure or Map with progress statistics
  Future<Either<Failure, Map<String, int>?>> call(String pathId) async {
    // Validate path ID
    if (pathId.isEmpty) {
      return left(ValidationFailure('Path ID cannot be empty'));
    }

    return await _repository.getProgressStatistics(pathId);
  }
}
