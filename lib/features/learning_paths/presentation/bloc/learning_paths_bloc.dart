// learning_paths_bloc.dart
// Bloc for managing learning paths state
// Handles all learning path operations and state transitions

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/usecases/create_learning_path_usecase.dart';
import '../../domain/usecases/get_active_learning_path_usecase.dart';
import '../../domain/usecases/complete_course_usecase.dart';
import '../../domain/usecases/generate_sub_categories_usecase.dart';
import '../../domain/usecases/delete_learning_path_usecase.dart';
import 'learning_paths_event.dart';
import 'learning_paths_state.dart';

/// Bloc for managing learning paths state
/// Handles all learning path operations and state transitions
class LearningPathsBloc extends Bloc<LearningPathsEvent, LearningPathsState> {
  final GenerateSubCategoriesUseCase _generateSubCategoriesUseCase;
  final CreateLearningPathUseCase _createLearningPathUseCase;
  final GetActiveLearningPathUseCase _getActiveLearningPathUseCase;
  final CompleteCourseUseCase _completeCourseUseCase;
  final DeleteLearningPathUseCase _deleteLearningPathUseCase;

  /// Constructor
  LearningPathsBloc({
    required GenerateSubCategoriesUseCase generateSubCategoriesUseCase,
    required CreateLearningPathUseCase createLearningPathUseCase,
    required GetActiveLearningPathUseCase getActiveLearningPathUseCase,
    required CompleteCourseUseCase completeCourseUseCase,
    required DeleteLearningPathUseCase deleteLearningPathUseCase,
  }) : _generateSubCategoriesUseCase = generateSubCategoriesUseCase,
       _createLearningPathUseCase = createLearningPathUseCase,
       _getActiveLearningPathUseCase = getActiveLearningPathUseCase,
       _completeCourseUseCase = completeCourseUseCase,
       _deleteLearningPathUseCase = deleteLearningPathUseCase,
       super(const LearningPathsState.initial()) {
    // Register event handlers
    on<GenerateSubCategories>(_onGenerateSubCategories);
    on<SelectSubCategory>(_onSelectSubCategory);
    on<LoadActivePath>(_onLoadActivePath);
    on<CompleteCourse>(_onCompleteCourse);
    on<DeletePath>(_onDeletePath);
    on<Refresh>(_onRefresh);
  }

  /// Handles sub-category generation
  Future<void> _onGenerateSubCategories(
    GenerateSubCategories event,
    Emitter<LearningPathsState> emit,
  ) async {
    emit(const LearningPathsState.loadingSubCategories());

    final result = await _generateSubCategoriesUseCase(
      level: event.level,
      focusAreas: event.focusAreas,
    );

    result.fold(
      (failure) => emit(
        LearningPathsState.error(message: _mapFailureToMessage(failure)),
      ),
      (subCategories) => emit(
        LearningPathsState.subCategoriesLoaded(subCategories: subCategories),
      ),
    );
  }

  /// Handles sub-category selection and learning path creation
  Future<void> _onSelectSubCategory(
    SelectSubCategory event,
    Emitter<LearningPathsState> emit,
  ) async {
    emit(const LearningPathsState.loadingSubCategories());

    final result = await _createLearningPathUseCase(
      level: event.level,
      focusAreas: event.focusAreas,
      subCategory: event.subCategory,
    );

    result.fold(
      (failure) => emit(
        LearningPathsState.error(message: _mapFailureToMessage(failure)),
      ),
      (learningPath) =>
          emit(LearningPathsState.pathLoaded(learningPath: learningPath)),
    );
  }

  /// Handles loading the active learning path
  Future<void> _onLoadActivePath(
    LoadActivePath event,
    Emitter<LearningPathsState> emit,
  ) async {
    final result = await _getActiveLearningPathUseCase();

    result.fold(
      (failure) => emit(
        LearningPathsState.error(message: _mapFailureToMessage(failure)),
      ),
      (learningPath) {
        if (learningPath != null) {
          emit(LearningPathsState.pathLoaded(learningPath: learningPath));
        } else {
          emit(const LearningPathsState.initial());
        }
      },
    );
  }

  /// Handles course completion
  Future<void> _onCompleteCourse(
    CompleteCourse event,
    Emitter<LearningPathsState> emit,
  ) async {
    final result = await _completeCourseUseCase(event.courseNumber);

    result.fold(
      (failure) => emit(
        LearningPathsState.error(message: _mapFailureToMessage(failure)),
      ),
      (_) async {
        // Reload the learning path to get updated state
        final pathResult = await _getActiveLearningPathUseCase();
        pathResult.fold(
          (failure) => emit(
            LearningPathsState.error(message: _mapFailureToMessage(failure)),
          ),
          (learningPath) {
            if (learningPath != null) {
              emit(
                LearningPathsState.courseCompleted(
                  courseNumber: event.courseNumber,
                  updatedPath: learningPath,
                ),
              );
            }
          },
        );
      },
    );
  }

  /// Handles learning path deletion
  Future<void> _onDeletePath(
    DeletePath event,
    Emitter<LearningPathsState> emit,
  ) async {
    final result = await _deleteLearningPathUseCase();

    result.fold(
      (failure) => emit(
        LearningPathsState.error(message: _mapFailureToMessage(failure)),
      ),
      (_) => emit(const LearningPathsState.pathDeleted()),
    );
  }

  /// Handles refresh
  Future<void> _onRefresh(
    Refresh event,
    Emitter<LearningPathsState> emit,
  ) async {
    add(const LearningPathsEvent.loadActivePath());
  }

  /// Maps failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again.';
      case NetworkFailure:
        return 'Network error. Please check your connection.';
      case ValidationFailure:
        return 'Invalid input. Please check your selection.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
