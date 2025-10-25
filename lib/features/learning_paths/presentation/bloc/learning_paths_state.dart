// learning_paths_state.dart
// Bloc states for the Learning Paths feature
// Defines all possible states for the learning paths UI

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/learning_path.dart';
import '../../domain/entities/sub_category.dart';

part 'learning_paths_state.freezed.dart';

/// Sealed class for learning paths states
@freezed
class LearningPathsState with _$LearningPathsState {
  /// Initial state
  const factory LearningPathsState.initial() = Initial;

  /// Loading sub-categories
  const factory LearningPathsState.loadingSubCategories() =
      LoadingSubCategories;

  /// Sub-categories loaded successfully
  const factory LearningPathsState.subCategoriesLoaded({
    required List<SubCategory> subCategories,
  }) = SubCategoriesLoaded;

  /// Learning path loaded successfully
  const factory LearningPathsState.pathLoaded({
    required LearningPath learningPath,
  }) = PathLoaded;

  /// Course completed successfully
  const factory LearningPathsState.courseCompleted({
    required int courseNumber,
    required LearningPath updatedPath,
  }) = CourseCompleted;

  /// Path deleted successfully
  const factory LearningPathsState.pathDeleted() = PathDeleted;

  /// Error state
  const factory LearningPathsState.error({required String message}) = Error;
}

