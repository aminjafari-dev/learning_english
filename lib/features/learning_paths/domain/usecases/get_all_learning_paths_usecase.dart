// get_all_learning_paths_usecase.dart
// Use case for retrieving all learning paths
// Handles the business logic for getting all user's learning paths

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/learning_path.dart';
import '../repositories/learning_paths_repository.dart';

/// Use case for getting all learning paths
/// Handles the business logic for retrieving all user's learning paths
class GetAllLearningPathsUseCase {
  final LearningPathsRepository _repository;

  /// Constructor
  /// @param repository Learning paths repository
  GetAllLearningPathsUseCase({required LearningPathsRepository repository})
    : _repository = repository;

  /// Gets all learning paths
  /// @return Either Failure or List of all LearningPaths
  Future<Either<Failure, List<LearningPath>>> call() async {
    return await _repository.getAllLearningPaths();
  }
}

