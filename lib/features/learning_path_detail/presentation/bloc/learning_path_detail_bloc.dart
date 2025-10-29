// learning_path_detail_bloc.dart
// Bloc for managing learning path detail state
// Handles all learning path detail operations and state transitions

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure.dart';
import '../../domain/usecases/get_learning_path_by_id_usecase.dart';
import '../../domain/usecases/complete_course_usecase.dart';
import '../../domain/usecases/delete_learning_path_by_id_usecase.dart';
import 'learning_path_detail_event.dart';
import 'learning_path_detail_state.dart';

/// Bloc for managing learning path detail state
/// Handles all learning path detail operations and state transitions
class LearningPathDetailBloc
    extends Bloc<LearningPathDetailEvent, LearningPathDetailState> {
  final GetLearningPathByIdUseCase _getLearningPathByIdUseCase;
  final CompleteCourseUseCase _completeCourseUseCase;
  final DeleteLearningPathByIdUseCase _deleteLearningPathByIdUseCase;

  /// Constructor
  LearningPathDetailBloc({
    required GetLearningPathByIdUseCase getLearningPathByIdUseCase,
    required CompleteCourseUseCase completeCourseUseCase,
    required DeleteLearningPathByIdUseCase deleteLearningPathByIdUseCase,
  }) : _getLearningPathByIdUseCase = getLearningPathByIdUseCase,
       _completeCourseUseCase = completeCourseUseCase,
       _deleteLearningPathByIdUseCase = deleteLearningPathByIdUseCase,
       super(const LearningPathDetailState.initial()) {
    // Register event handlers
    on<LoadPathById>(_onLoadPathById);
    on<CompleteCourse>(_onCompleteCourse);
    on<DeletePath>(_onDeletePath);
    on<Refresh>(_onRefresh);
  }

  /// Handles loading a specific learning path by ID
  Future<void> _onLoadPathById(
    LoadPathById event,
    Emitter<LearningPathDetailState> emit,
  ) async {
    if (!emit.isDone) {
      emit(const LearningPathDetailState.loading());
    }

    final result = await _getLearningPathByIdUseCase(event.pathId);

    if (!emit.isDone) {
      result.fold(
        (failure) => emit(
          LearningPathDetailState.error(message: _mapFailureToMessage(failure)),
        ),
        (learningPath) {
          if (!emit.isDone) {
            if (learningPath != null) {
              emit(
                LearningPathDetailState.pathLoaded(learningPath: learningPath),
              );
            } else {
              emit(const LearningPathDetailState.initial());
            }
          }
        },
      );
    }
  }

  /// Handles course completion
  Future<void> _onCompleteCourse(
    CompleteCourse event,
    Emitter<LearningPathDetailState> emit,
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
                  LearningPathDetailState.error(
                    message: _mapFailureToMessage(failure),
                  ),
                );
              }
            },
            (learningPath) {
              if (!emit.isDone && learningPath != null) {
                emit(
                  LearningPathDetailState.courseCompleted(
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
            LearningPathDetailState.error(
              message: _mapFailureToMessage(failure),
            ),
          );
        }
      }
    }
  }

  /// Handles learning path deletion
  Future<void> _onDeletePath(
    DeletePath event,
    Emitter<LearningPathDetailState> emit,
  ) async {
    // First, emit loading state to show user that deletion is in progress
    if (!emit.isDone) {
      emit(const LearningPathDetailState.loading());
    }

    final result = await _deleteLearningPathByIdUseCase(event.pathId);

    // Check if emitter is still valid after async operation
    if (!emit.isDone) {
      // Check if deletion was successful
      final isSuccess = result.fold((failure) => false, (_) => true);

      if (isSuccess) {
        // Deletion was successful
        if (!emit.isDone) {
          emit(const LearningPathDetailState.pathDeleted());
        }
      } else {
        // Handle deletion failure - emit error
        final failure = result.fold((failure) => failure, (_) => null);

        if (!emit.isDone && failure != null) {
          emit(
            LearningPathDetailState.error(
              message: _mapFailureToMessage(failure),
            ),
          );
        }
      }
    }
  }

  /// Handles refresh
  Future<void> _onRefresh(
    Refresh event,
    Emitter<LearningPathDetailState> emit,
  ) async {
    // This will be handled by the parent widget that knows the pathId
    // For now, just emit the current state
    if (!emit.isDone) {
      emit(const LearningPathDetailState.initial());
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
