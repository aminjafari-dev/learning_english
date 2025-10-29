// learning_paths_bloc.dart
// Bloc for managing learning paths state
// Handles all learning path operations and state transitions

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/usecases/create_learning_path_usecase.dart';
import '../../domain/usecases/get_all_learning_paths_usecase.dart';
import '../../domain/usecases/get_learning_path_by_id_usecase.dart';
import '../../domain/usecases/get_active_learning_path_usecase.dart';
import '../../domain/usecases/complete_course_usecase.dart';
import '../../domain/usecases/generate_sub_categories_usecase.dart';
import '../../domain/usecases/delete_learning_path_by_id_usecase.dart';
import 'learning_paths_event.dart';
import 'learning_paths_state.dart';

/// Bloc for managing learning paths state
/// Handles all learning path operations and state transitions
class LearningPathsBloc extends Bloc<LearningPathsEvent, LearningPathsState> {
  final GenerateSubCategoriesUseCase _generateSubCategoriesUseCase;
  final CreateLearningPathUseCase _createLearningPathUseCase;
  final GetAllLearningPathsUseCase _getAllLearningPathsUseCase;
  final GetLearningPathByIdUseCase _getLearningPathByIdUseCase;
  final GetActiveLearningPathUseCase _getActiveLearningPathUseCase;
  final CompleteCourseUseCase _completeCourseUseCase;
  final DeleteLearningPathByIdUseCase _deleteLearningPathByIdUseCase;

  /// Constructor
  LearningPathsBloc({
    required GenerateSubCategoriesUseCase generateSubCategoriesUseCase,
    required CreateLearningPathUseCase createLearningPathUseCase,
    required GetAllLearningPathsUseCase getAllLearningPathsUseCase,
    required GetLearningPathByIdUseCase getLearningPathByIdUseCase,
    required GetActiveLearningPathUseCase getActiveLearningPathUseCase,
    required CompleteCourseUseCase completeCourseUseCase,
    required DeleteLearningPathByIdUseCase deleteLearningPathByIdUseCase,
  }) : _generateSubCategoriesUseCase = generateSubCategoriesUseCase,
       _createLearningPathUseCase = createLearningPathUseCase,
       _getAllLearningPathsUseCase = getAllLearningPathsUseCase,
       _getLearningPathByIdUseCase = getLearningPathByIdUseCase,
       _getActiveLearningPathUseCase = getActiveLearningPathUseCase,
       _completeCourseUseCase = completeCourseUseCase,
       _deleteLearningPathByIdUseCase = deleteLearningPathByIdUseCase,
       super(const LearningPathsState.initial()) {
    // Register event handlers
    on<GenerateSubCategories>(_onGenerateSubCategories);
    on<SelectSubCategory>(_onSelectSubCategory);
    on<LoadAllPaths>(_onLoadAllPaths);
    on<LoadPathById>(_onLoadPathById);
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
    if (!emit.isDone) {
      emit(const LearningPathsState.loadingSubCategories());

      final result = await _generateSubCategoriesUseCase(
        level: event.level,
        focusAreas: event.focusAreas,
      );

      if (!emit.isDone) {
        result.fold(
          (failure) => emit(
            LearningPathsState.error(message: _mapFailureToMessage(failure)),
          ),
          (subCategories) => emit(
            LearningPathsState.subCategoriesLoaded(
              subCategories: subCategories,
            ),
          ),
        );
      }
    }
  }

  /// Handles sub-category selection and learning path creation
  Future<void> _onSelectSubCategory(
    SelectSubCategory event,
    Emitter<LearningPathsState> emit,
  ) async {
    if (!emit.isDone) {
      emit(const LearningPathsState.loadingSubCategories());

      final result = await _createLearningPathUseCase(
        level: event.level,
        focusAreas: event.focusAreas,
        subCategory: event.subCategory,
      );

      if (!emit.isDone) {
        result.fold(
          (failure) => emit(
            LearningPathsState.error(message: _mapFailureToMessage(failure)),
          ),
          (learningPath) =>
              emit(LearningPathsState.pathLoaded(learningPath: learningPath)),
        );
      }
    }
  }

  /// Handles loading all learning paths
  Future<void> _onLoadAllPaths(
    LoadAllPaths event,
    Emitter<LearningPathsState> emit,
  ) async {
    final result = await _getAllLearningPathsUseCase();

    if (!emit.isDone) {
      result.fold(
        (failure) => emit(
          LearningPathsState.error(message: _mapFailureToMessage(failure)),
        ),
        (learningPaths) {
          if (!emit.isDone) {
            if (learningPaths.isNotEmpty) {
              emit(
                LearningPathsState.allPathsLoaded(learningPaths: learningPaths),
              );
            } else {
              emit(const LearningPathsState.initial());
            }
          }
        },
      );
    }
  }

  /// Handles loading a specific learning path by ID
  Future<void> _onLoadPathById(
    LoadPathById event,
    Emitter<LearningPathsState> emit,
  ) async {
    final result = await _getLearningPathByIdUseCase(event.pathId);

    if (!emit.isDone) {
      result.fold(
        (failure) => emit(
          LearningPathsState.error(message: _mapFailureToMessage(failure)),
        ),
        (learningPath) {
          if (!emit.isDone) {
            if (learningPath != null) {
              emit(LearningPathsState.pathLoaded(learningPath: learningPath));
            } else {
              emit(const LearningPathsState.initial());
            }
          }
        },
      );
    }
  }

  /// Handles loading the active learning path (for backward compatibility)
  Future<void> _onLoadActivePath(
    LoadActivePath event,
    Emitter<LearningPathsState> emit,
  ) async {
    final result = await _getActiveLearningPathUseCase();

    if (!emit.isDone) {
      result.fold(
        (failure) => emit(
          LearningPathsState.error(message: _mapFailureToMessage(failure)),
        ),
        (learningPath) {
          if (!emit.isDone) {
            if (learningPath != null) {
              emit(LearningPathsState.pathLoaded(learningPath: learningPath));
            } else {
              emit(const LearningPathsState.initial());
            }
          }
        },
      );
    }
  }

  /// Handles course completion
  Future<void> _onCompleteCourse(
    CompleteCourse event,
    Emitter<LearningPathsState> emit,
  ) async {
    final result = await _completeCourseUseCase(
      event.pathId,
      event.courseNumber,
    );

    if (!emit.isDone) {
      // Check if course completion was successful
      final isSuccess = result.fold((failure) => false, (_) => true);

      if (isSuccess) {
        // Reload the learning path to get updated state
        final pathResult = await _getLearningPathByIdUseCase(event.pathId);

        if (!emit.isDone) {
          pathResult.fold(
            (failure) {
              if (!emit.isDone) {
                emit(
                  LearningPathsState.error(
                    message: _mapFailureToMessage(failure),
                  ),
                );
              }
            },
            (learningPath) {
              if (!emit.isDone && learningPath != null) {
                emit(
                  LearningPathsState.courseCompleted(
                    courseNumber: event.courseNumber,
                    updatedPath: learningPath,
                  ),
                );
              }
            },
          );
        }
      } else {
        // Handle course completion failure - emit error
        final failure = result.fold((failure) => failure, (_) => null);

        if (!emit.isDone && failure != null) {
          emit(
            LearningPathsState.error(message: _mapFailureToMessage(failure)),
          );
        }
      }
    }
  }

  /// Handles learning path deletion
  Future<void> _onDeletePath(
    DeletePath event,
    Emitter<LearningPathsState> emit,
  ) async {
    // First, emit loading state to show user that deletion is in progress
    if (!emit.isDone) {
      emit(const LearningPathsState.loadingSubCategories());
    }

    final result = await _deleteLearningPathByIdUseCase(event.pathId);

    // Check if emitter is still valid after async operation
    if (!emit.isDone) {
      // Check if deletion was successful
      final isSuccess = result.fold((failure) => false, (_) => true);

      if (isSuccess) {
        // Deletion was successful, now reload all remaining paths
        // Use the helper method to safely refresh the list
        await _refreshLearningPathsList(emit);
      } else {
        // Handle deletion failure - emit error
        final failure = result.fold((failure) => failure, (_) => null);

        if (!emit.isDone && failure != null) {
          emit(
            LearningPathsState.error(message: _mapFailureToMessage(failure)),
          );
        }
      }
    }
  }

  /// Handles refresh
  Future<void> _onRefresh(
    Refresh event,
    Emitter<LearningPathsState> emit,
  ) async {
    // Use the helper method to safely refresh the list
    await _refreshLearningPathsList(emit);
  }

  /// Helper method to safely refresh the learning paths list
  /// This method handles all the emit.isDone checks properly
  Future<void> _refreshLearningPathsList(
    Emitter<LearningPathsState> emit,
  ) async {
    if (!emit.isDone) {
      final result = await _getAllLearningPathsUseCase();

      if (!emit.isDone) {
        result.fold(
          (failure) {
            if (!emit.isDone) {
              emit(
                LearningPathsState.error(
                  message: _mapFailureToMessage(failure),
                ),
              );
            }
          },
          (learningPaths) {
            if (!emit.isDone) {
              if (learningPaths.isNotEmpty) {
                emit(
                  LearningPathsState.allPathsLoaded(
                    learningPaths: learningPaths,
                  ),
                );
              } else {
                emit(const LearningPathsState.initial());
              }
            }
          },
        );
      }
    }
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
