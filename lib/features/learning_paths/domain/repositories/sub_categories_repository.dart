// sub_categories_repository.dart
// Domain repository interface for sub-categories
// Defines the contract for sub-category generation operations

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/sub_category.dart';
import '../../../level_selection/domain/entities/user_profile.dart';

/// Repository interface for sub-categories operations
/// Defines the contract for AI-generated sub-category management
abstract class SubCategoriesRepository {
  /// Generates sub-categories using AI based on level and focus areas
  /// @param level User's English proficiency level
  /// @param focusAreas List of focus areas for learning
  /// @return Either Failure or List of generated SubCategories
  Future<Either<Failure, List<SubCategory>>> generateSubCategories({
    required Level level,
    required List<String> focusAreas,
  });
}
