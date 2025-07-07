// This file defines the LevelEvent sealed class for the level selection feature.
// Usage: Used by LevelBloc to handle user actions.
// Example:
//   context.read<LevelBloc>().add(LevelEvent.levelSelected(Level.beginner));

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';

part 'level_event.freezed.dart';

@freezed
class LevelEvent with _$LevelEvent {
  /// Event when a level is selected
  const factory LevelEvent.levelSelected(Level level) = LevelSelected;

  /// Event when the user submits their selection
  const factory LevelEvent.levelSubmitted(String userId) = LevelSubmitted;
}
