// generate_sub_categories_usecase.dart
// Use case for generating sub-categories
// Handles the business logic for AI-generated sub-category creation

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/sub_category.dart';
import '../repositories/sub_categories_repository.dart';
import '../../../level_selection/domain/entities/user_profile.dart';

/// Use case for generating sub-categories
/// Handles the business logic for AI-generated sub-category creation
class GenerateSubCategoriesUseCase {
  final SubCategoriesRepository _repository;

  /// Constructor
  /// @param repository Sub-categories repository
  GenerateSubCategoriesUseCase({required SubCategoriesRepository repository})
    : _repository = repository;

  /// Generates sub-categories using AI
  /// @param level User's English proficiency level
  /// @param focusAreas List of focus areas for learning
  /// @return Either Failure or List of generated SubCategories
  Future<Either<Failure, List<SubCategory>>> call({
    required Level level,
    required List<String> focusAreas,
  }) async {
    // Validate inputs
    if (focusAreas.isEmpty) {
      return left(ValidationFailure('Focus areas cannot be empty'));
    }

    // Generate sub-categories
    return await _repository.generateSubCategories(
      level: level,
      focusAreas: focusAreas,
    );
  }
}
