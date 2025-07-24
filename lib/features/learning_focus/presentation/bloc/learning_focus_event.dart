// learning_focus_event.dart
// Events for the learning focus BLoC.
//
// Usage Example:
//   context.read<LearningFocusBloc>().add(
//     LearningFocusEvent.loadOptions(),
//   );
//
// This file defines all events that can be dispatched to the learning focus BLoC.

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/learning_focus.dart';

part 'learning_focus_event.freezed.dart';

@freezed
class LearningFocusEvent with _$LearningFocusEvent {
  /// Event to load all learning focus options
  const factory LearningFocusEvent.loadOptions() = LoadOptions;

  /// Event when a learning focus option is selected/deselected
  const factory LearningFocusEvent.toggleSelection(LearningFocusType focusType) = ToggleSelection;

  /// Event to save the user's selected learning focus preferences
  const factory LearningFocusEvent.saveSelections(String userId) = SaveSelections;

  /// Event to load user's existing learning focus preferences
  const factory LearningFocusEvent.loadUserSelections(String userId) = LoadUserSelections;
}
