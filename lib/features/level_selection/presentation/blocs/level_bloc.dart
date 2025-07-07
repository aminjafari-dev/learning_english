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


/// Bloc for managing level selection and submission
class LevelBloc extends Bloc<LevelEvent, LevelState> {
  final SaveUserLevelUseCase saveUserLevelUseCase;
  Level? _selectedLevel;

  LevelBloc({required this.saveUserLevelUseCase})
    : super(const LevelState.initial()) {
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
      emit(const LevelState.error('No level selected'));
      return;
    }
    emit(const LevelState.loading());
    final result = await saveUserLevelUseCase(event.userId, _selectedLevel!);
    result.fold(
      (failure) => emit(LevelState.error(failure.message)),
      (_) => emit(const LevelState.success()),
    );
  }
}
