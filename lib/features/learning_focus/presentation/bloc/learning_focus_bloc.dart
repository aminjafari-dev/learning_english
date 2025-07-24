// learning_focus_bloc.dart
// BLoC for managing learning focus state and events.
//
// Usage Example:
//   BlocProvider(
//     create: (_) => getIt<LearningFocusBloc>()..add(LearningFocusEvent.loadOptions()),
//     child: LearningFocusPage(),
//   );
//
// This BLoC handles learning focus selection and saving user preferences.

import 'package:bloc/bloc.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../../domain/entities/learning_focus.dart';
import '../../domain/entities/user_learning_focus.dart';
import '../../domain/usecases/get_learning_focus_options_usecase.dart';
import '../../domain/usecases/get_user_learning_focus_usecase.dart';
import '../../domain/usecases/save_user_learning_focus_usecase.dart';
import 'learning_focus_event.dart';
import 'learning_focus_state.dart';

class LearningFocusBloc extends Bloc<LearningFocusEvent, LearningFocusState> {
  final GetLearningFocusOptionsUseCase getLearningFocusOptionsUseCase;
  final SaveUserLearningFocusUseCase saveUserLearningFocusUseCase;
  final GetUserLearningFocusUseCase getUserLearningFocusUseCase;

  List<LearningFocus> _currentOptions = [];

  LearningFocusBloc({
    required this.getLearningFocusOptionsUseCase,
    required this.saveUserLearningFocusUseCase,
    required this.getUserLearningFocusUseCase,
  }) : super(const LearningFocusState.initial()) {
    on<LearningFocusEvent>((event, emit) async {
      await event.when(
        loadOptions: () => _onLoadOptions(emit),
        toggleSelection: (focusType) => _onToggleSelection(emit, focusType),
        saveSelections: (userId) => _onSaveSelections(emit, userId),
        loadUserSelections: (userId) => _onLoadUserSelections(emit, userId),
      );
    });
  }

  Future<void> _onLoadOptions(Emitter<LearningFocusState> emit) async {
    try {
      emit(const LearningFocusState.loading());

      final result = await getLearningFocusOptionsUseCase(NoParams());
      result.fold(
        (failure) => emit(LearningFocusState.error(failure.message)),
        (options) {
          _currentOptions = options;
          emit(LearningFocusState.loaded(options));
        },
      );
    } catch (e) {
      emit(
        LearningFocusState.error(
          'Failed to load learning focus options: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onToggleSelection(
    Emitter<LearningFocusState> emit,
    LearningFocusType focusType,
  ) async {
    try {
      final updatedOptions =
          _currentOptions.map((option) {
            if (option.type == focusType) {
              return option.copyWith(isSelected: !option.isSelected);
            }
            return option;
          }).toList();

      _currentOptions = updatedOptions;
      emit(LearningFocusState.loaded(updatedOptions));
    } catch (e) {
      emit(
        LearningFocusState.error('Failed to toggle selection: ${e.toString()}'),
      );
    }
  }

  Future<void> _onSaveSelections(
    Emitter<LearningFocusState> emit,
    String userId,
  ) async {
    try {
      emit(const LearningFocusState.loading());

      final selectedTypes =
          _currentOptions
              .where((option) => option.isSelected)
              .map((option) => option.type)
              .toList();

      final userLearningFocus = UserLearningFocus(
        userId: userId,
        selectedFocuses: selectedTypes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final result = await saveUserLearningFocusUseCase(
        SaveUserLearningFocusParams(userLearningFocus: userLearningFocus),
      );

      result.fold(
        (failure) => emit(LearningFocusState.error(failure.message)),
        (_) => emit(const LearningFocusState.success()),
      );
    } catch (e) {
      emit(
        LearningFocusState.error('Failed to save selections: ${e.toString()}'),
      );
    }
  }

  Future<void> _onLoadUserSelections(
    Emitter<LearningFocusState> emit,
    String userId,
  ) async {
    try {
      final result = await getUserLearningFocusUseCase(
        GetUserLearningFocusParams(userId: userId),
      );

      result.fold(
        (failure) => emit(LearningFocusState.error(failure.message)),
        (userLearningFocus) {
          if (userLearningFocus != null) {
            final updatedOptions =
                _currentOptions.map((option) {
                  final isSelected = userLearningFocus.selectedFocuses.contains(
                    option.type,
                  );
                  return option.copyWith(isSelected: isSelected);
                }).toList();

            _currentOptions = updatedOptions;
            emit(LearningFocusState.loaded(updatedOptions));
          }
        },
      );
    } catch (e) {
      emit(
        LearningFocusState.error(
          'Failed to load user selections: ${e.toString()}',
        ),
      );
    }
  }
}
