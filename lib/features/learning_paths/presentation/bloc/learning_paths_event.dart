// learning_paths_event.dart
// Bloc events for the Learning Paths feature
// Defines all possible user actions and system events

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/sub_category.dart';
import '../../../level_selection/domain/entities/user_profile.dart';

part 'learning_paths_event.freezed.dart';

/// Sealed class for learning paths events
@freezed
class LearningPathsEvent with _$LearningPathsEvent {
  /// Event to generate sub-categories based on level and focus areas
  const factory LearningPathsEvent.generateSubCategories({
    required Level level,
    required List<String> focusAreas,
  }) = GenerateSubCategories;

  /// Event to select a sub-category and create a learning path
  const factory LearningPathsEvent.selectSubCategory({
    required SubCategory subCategory,
    required Level level,
    required List<String> focusAreas,
  }) = SelectSubCategory;

  /// Event to load all learning paths
  const factory LearningPathsEvent.loadAllPaths() = LoadAllPaths;

  /// Event to load a specific learning path by ID
  const factory LearningPathsEvent.loadPathById({required String pathId}) =
      LoadPathById;

  /// Event to load the active learning path (for backward compatibility)
  const factory LearningPathsEvent.loadActivePath() = LoadActivePath;

  /// Event to complete a course in a specific learning path
  const factory LearningPathsEvent.completeCourse({
    required String pathId,
    required int courseNumber,
  }) = CompleteCourse;

  /// Event to delete a specific learning path by ID
  const factory LearningPathsEvent.deletePath({required String pathId}) =
      DeletePath;

  /// Event to refresh the current state
  const factory LearningPathsEvent.refresh() = Refresh;
}
