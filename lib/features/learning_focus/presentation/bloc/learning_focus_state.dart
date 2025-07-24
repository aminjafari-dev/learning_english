// learning_focus_state.dart
// States for the learning focus BLoC.
//
// Usage Example:
//   BlocBuilder<LearningFocusBloc, LearningFocusState>(
//     builder: (context, state) {
//       return state.when(
//         initial: () => LoadingWidget(),
//         loading: () => LoadingWidget(),
//         loaded: (options) => OptionsGrid(options),
//         error: (message) => ErrorWidget(message),
//         success: () => SuccessWidget(),
//       );
//     },
//   );
//
// This file defines all possible states for the learning focus BLoC.

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/learning_focus.dart';

part 'learning_focus_state.freezed.dart';

@freezed
class LearningFocusState with _$LearningFocusState {
  /// Initial state
  const factory LearningFocusState.initial() = Initial;

  /// Loading state
  const factory LearningFocusState.loading() = Loading;

  /// State when learning focus options are loaded
  const factory LearningFocusState.loaded(List<LearningFocus> options) = Loaded;

  /// Error state
  const factory LearningFocusState.error(String message) = Error;

  /// Success state when selections are saved
  const factory LearningFocusState.success() = Success;
}
