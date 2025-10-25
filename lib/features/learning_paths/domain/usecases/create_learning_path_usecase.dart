// create_learning_path_usecase.dart
// Use case for creating a new learning path
// Orchestrates the creation of a learning path with sub-category selection

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/learning_path.dart';
import '../entities/sub_category.dart';
import '../repositories/learning_paths_repository.dart';
import '../../../level_selection/domain/entities/user_profile.dart';

/// Use case for creating a new learning path
/// Handles the business logic for creating a learning path with sub-category
class CreateLearningPathUseCase {
  final LearningPathsRepository _repository;

  /// Constructor
  /// @param repository Learning paths repository
  CreateLearningPathUseCase({required LearningPathsRepository repository})
    : _repository = repository;

  /// Creates a new learning path
  /// @param level User's English proficiency level
  /// @param focusAreas List of focus areas for learning
  /// @param subCategory Selected sub-category for the learning path
  /// @return Either Failure or the created LearningPath
  Future<Either<Failure, LearningPath>> call({
    required Level level,
    required List<String> focusAreas,
    required SubCategory subCategory,
  }) async {
    // Validate inputs
    if (focusAreas.isEmpty) {
      return left(ValidationFailure('Focus areas cannot be empty'));
    }

    if (subCategory.id.isEmpty || subCategory.title.isEmpty) {
      return left(ValidationFailure('Invalid sub-category selected'));
    }

    // Create the learning path
    return await _repository.createLearningPath(
      level: level,
      focusAreas: focusAreas,
      subCategory: subCategory,
    );
  }
}
