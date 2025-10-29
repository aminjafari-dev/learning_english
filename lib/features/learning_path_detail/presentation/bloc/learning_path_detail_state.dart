// learning_path_detail_state.dart
// Bloc states for the Learning Path Detail feature
// Defines all possible states for the learning path detail UI

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/learning_path.dart';

part 'learning_path_detail_state.freezed.dart';

/// Sealed class for learning path detail states
@freezed
class LearningPathDetailState with _$LearningPathDetailState {
  /// Initial state
  const factory LearningPathDetailState.initial() = Initial;

  /// Loading state
  const factory LearningPathDetailState.loading() = Loading;

  /// Learning path loaded successfully
  const factory LearningPathDetailState.pathLoaded({
    required LearningPath learningPath,
  }) = PathLoaded;

  /// Course completed successfully
  const factory LearningPathDetailState.courseCompleted({
    required int courseNumber,
    required LearningPath updatedPath,
  }) = CourseCompleted;

  /// Learning path deleted successfully
  const factory LearningPathDetailState.pathDeleted() = PathDeleted;

  /// Error state
  const factory LearningPathDetailState.error({required String message}) =
      Error;
}
