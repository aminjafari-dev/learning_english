// learning_path_detail_event.dart
// Bloc events for the Learning Path Detail feature
// Defines all possible user actions and system events

import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_path_detail_event.freezed.dart';

/// Sealed class for learning path detail events
@freezed
class LearningPathDetailEvent with _$LearningPathDetailEvent {
  /// Event to load a specific learning path by ID
  const factory LearningPathDetailEvent.loadPathById({required String pathId}) =
      LoadPathById;

  /// Event to complete a course in a specific learning path
  const factory LearningPathDetailEvent.completeCourse({
    required String pathId,
    required int courseNumber,
  }) = CompleteCourse;

  /// Event to delete a specific learning path by ID
  const factory LearningPathDetailEvent.deletePath({required String pathId}) =
      DeletePath;

  /// Event to refresh the current state
  const factory LearningPathDetailEvent.refresh() = Refresh;
}
