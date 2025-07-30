// This file defines the LevelBloc, events, and states for the level selection feature.
// Usage: Provides state management for selecting and submitting English level.
// Example:
//   BlocProvider(
//     create: (_) => LevelBloc(saveUserLevelUseCase: ...),
//     child: LevelSelectionPage(),
//   );

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';
import 'package:learning_english/features/level_selection/domain/usecases/save_user_level_usecase.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_event.dart';
import 'package:learning_english/features/level_selection/presentation/blocs/level_state.dart';
import 'package:learning_english/core/usecase/get_user_id_usecase.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/core/error/firebase_failure.dart';

/// Bloc for managing level selection and submission
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

  void _onLevelSelected(LevelSelected event, Emitter<LevelState> emit) {
    _selectedLevel = event.level;
    emit(LevelState.selectionMade(event.level));
  }

  Future<void> _onLevelSubmitted(
    LevelSubmitted event,
    Emitter<LevelState> emit,
  ) async {
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
      // Handle different types of Firebase failures with user-friendly messages
      String errorMessage;

      // Check if this is a Firebase-related error by examining the message
      if (failure.message.contains('regional') ||
          failure.message.contains('restricted') ||
          failure.message.contains('VPN')) {
        errorMessage =
            'Firebase services are restricted in your region. Please try using a VPN or contact support.';
      } else if (failure.message.contains('network') ||
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
