// This file defines the LevelState sealed class for the level selection feature.
// Usage: Used by LevelBloc to represent UI state.
// Example:
//   BlocBuilder<LevelBloc, LevelState>(builder: ...)

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';

part 'level_state.freezed.dart';

@freezed
class LevelState with _$LevelState {
  /// Initial state
  const factory LevelState.initial() = LevelInitial;

  /// State when a level is selected
  const factory LevelState.selectionMade(Level level) = LevelSelectionMade;

  /// State when loading (with selected level maintained)
  const factory LevelState.loading(Level level) = LevelLoading;

  /// State when submission is successful (with selected level maintained)
  const factory LevelState.success(Level level) = LevelSuccess;

  /// State when an error occurs (with selected level maintained)
  const factory LevelState.error(String message, Level? level) = LevelError;
}
