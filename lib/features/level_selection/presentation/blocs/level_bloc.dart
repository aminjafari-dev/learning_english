// This file defines the LevelBloc, events, and states for the level selection feature.
// Usage: Provides state management for selecting and submitting English level.
// Example:
//   BlocProvider(
//     create: (_) => LevelBloc(saveUserLevelUseCase: ...),
//     child: LevelSelectionPage(),
//   );

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';
import 'package:learning_english/features/level_selection/domain/usecases/save_user_level_usecase.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_event.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_state.dart';
import 'package:learning_english/core/usecase/get_user_id_usecase.dart';
import 'package:learning_english/core/usecase/usecase.dart';

/// Bloc for managing level selection and submission
/// Now navigates immediately when a level is selected, without waiting for Firebase response
/// Errors are handled silently without showing anything to the user
class LevelBloc extends Bloc<LevelEvent, LevelState> {
  final SaveUserLevelUseCase saveUserLevelUseCase;
  final GetUserIdUseCase getUserIdUseCase;
  Level? _selectedLevel;

  LevelBloc({
    required this.saveUserLevelUseCase,
    required this.getUserIdUseCase,
  }) : super(const LevelState.initial()) {
    on<LevelSelected>(_onLevelSelected);
    on<LevelSubmitted>(_onLevelSubmitted);
  }

  /// Immediately navigates when a level is selected, without waiting for Firebase response
  /// Firebase operations happen in the background and errors are handled silently
  Future<void> _onLevelSelected(
    LevelSelected event,
    Emitter<LevelState> emit,
  ) async {
    _selectedLevel = event.level;

    // Immediately emit success to trigger navigation
    emit(LevelState.success(event.level));

    // Handle backend operations in the background without affecting UI
    _handleBackgroundOperation(event.level);
  }

  /// Handles backend operations in the background without affecting UI
  /// Errors are logged but not shown to the user
  Future<void> _handleBackgroundOperation(Level level) async {
    try {
      // Retrieve userId from local storage using the use case
      final userIdResult = await getUserIdUseCase(NoParams());
      final userId = userIdResult.fold((failure) => null, (id) => id);

      if (userId != null) {
        final result = await saveUserLevelUseCase(userId, level);
        result.fold(
          (failure) {
            // Log error silently without showing to user
            // In production, use proper logging framework
            debugPrint('Level selection error: ${failure.message}');
          },
          (_) {
            // Success - no action needed since navigation already happened
            debugPrint('Level selection saved successfully to backend');
          },
        );
      } else {
        // Log error silently without showing to user
        debugPrint('User ID not found for level selection');
      }
    } catch (e) {
      // Log any unexpected errors silently
      debugPrint('Unexpected error during level selection: $e');
    }
  }

  /// Legacy method - kept for backward compatibility but no longer needed
  /// since level submission now happens automatically on selection
  Future<void> _onLevelSubmitted(
    LevelSubmitted event,
    Emitter<LevelState> emit,
  ) async {
    // This method is now redundant since submission happens automatically
    // but kept for backward compatibility
    if (_selectedLevel == null) {
      emit(const LevelState.error('No level selected', null));
      return;
    }
    emit(LevelState.loading(_selectedLevel!));
    // Retrieve userId from local storage using the use case
    final userIdResult = await getUserIdUseCase(NoParams());
    final userId = userIdResult.fold((failure) => null, (id) => id);
    if (userId == null) {
      emit(
        LevelState.error(
          'User ID not found. Please log in again.',
          _selectedLevel,
        ),
      );
      return;
    }
    final result = await saveUserLevelUseCase(userId, _selectedLevel!);
    result.fold((failure) {
      // Handle different types of backend failures with user-friendly messages
      String errorMessage;

      // Check if this is a network-related error by examining the message
      if (failure.message.contains('network') ||
          failure.message.contains('connection')) {
        errorMessage =
            'Network connection failed. Please check your internet connection and try again.';
      } else if (failure.message.contains('permission') ||
          failure.message.contains('denied')) {
        errorMessage =
            'Access denied. You don\'t have permission to perform this action.';
      } else if (failure.message.contains('timeout') ||
          failure.message.contains('deadline')) {
        errorMessage = 'Operation timed out. Please try again.';
      } else {
        errorMessage = failure.message;
      }

      emit(LevelState.error(errorMessage, _selectedLevel));
    }, (_) => emit(LevelState.success(_selectedLevel!)));
  }
}
