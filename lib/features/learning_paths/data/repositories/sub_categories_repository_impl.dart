// sub_categories_repository_impl.dart
// Implementation of SubCategoriesRepository
// Handles AI generation of sub-categories

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/sub_category.dart';
import '../../domain/repositories/sub_categories_repository.dart';
import '../datasources/remote/sub_category_generation_service.dart';
import '../../../level_selection/domain/entities/user_profile.dart';

/// Implementation of SubCategoriesRepository
/// Handles AI generation of sub-categories using Gemini API
class SubCategoriesRepositoryImpl implements SubCategoriesRepository {
  final SubCategoryGenerationService _generationService;

  /// Constructor
  /// @param generationService AI service for generating sub-categories
  SubCategoriesRepositoryImpl({
    required SubCategoryGenerationService generationService,
  }) : _generationService = generationService;

  @override
  Future<Either<Failure, List<SubCategory>>> generateSubCategories({
    required Level level,
    required List<String> focusAreas,
  }) async {
    try {
      print(
        '🚀 [SUB_CATEGORIES_REPO] Generating sub-categories for level: ${level.name}, focus: $focusAreas',
      );

      // Generate sub-categories using AI service
      final result = await _generationService.generateSubCategories(
        level: level,
        focusAreas: focusAreas,
      );

      // Handle the Either result
      return result.fold(
        (failure) {
          print(
            '❌ [SUB_CATEGORIES_REPO] AI generation failed: ${failure.message}',
          );
          return left(failure);
        },
        (subCategoryModels) {
          // Convert models to domain entities
          final subCategories =
              subCategoryModels.map((model) => model.toEntity()).toList();

          print(
            '✅ [SUB_CATEGORIES_REPO] Generated ${subCategories.length} sub-categories',
          );
          return right(subCategories);
        },
      );
    } catch (e) {
      print('❌ [SUB_CATEGORIES_REPO] Error generating sub-categories: $e');
      return left(
        ServerFailure('Failed to generate sub-categories: ${e.toString()}'),
      );
    }
  }
}
