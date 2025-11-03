// courses_bloc.dart
// Bloc for managing courses operations.
// Generates personalized lessons based on user preferences.
// Now includes user-specific data management and analytics functionality.
// Now supports personalized content generation based on user preferences.

import 'package:bloc/bloc.dart';
import 'courses_event.dart';
import 'courses_state.dart';
import '../../domain/usecases/complete_course_usecase.dart';
import '../../domain/repositories/courses_repository.dart';
import 'package:learning_english/features/learning_paths/domain/entities/learning_path.dart';

/// Bloc for managing courses (vocabularies and phrases)
/// Generates personalized lessons based on learning path information
/// Includes user-specific data management and analytics functionality
class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final CompleteCourseUseCase completeCourseUseCase;
  final CoursesRepository coursesRepository;

  CoursesBloc({
    required this.completeCourseUseCase,
    required this.coursesRepository,
  }) : super(
         const CoursesState(
           vocabularies: VocabulariesState.initial(),
           phrases: PhrasesState.initial(),
           userPreferences: UserPreferencesState.initial(),
           analytics: UserAnalyticsState.initial(),
           dataManagement: UserDataManagementState.initial(),
           courseCompletion: CourseCompletionState.initial(),
           isRefreshing: false,
         ),
       ) {
    on<CoursesEvent>((event, emit) async {
      await event.when(
        fetchLessons: () => _onFetchCourses(emit), // Fetch courses
        fetchLessonsWithCourseContext:
            (pathId, courseNumber, learningPath) =>
                _onFetchLessonsWithCourseContext(
                  emit,
                  pathId,
                  courseNumber,
                  learningPath,
                ), // Course-specific content
        refreshLessons: () => _onRefreshLessons(emit),
        getUserPreferences: () => _onGetUserPreferences(emit),
        completeCourse:
            (pathId, courseNumber) => _onCompleteCourse(
              emit,
              pathId,
              courseNumber,
            ), // Course completion
      );
    });
  }

  /// Placeholder method for fetchLessons event
  /// This should not be called anymore as courses are always accessed through learning paths
  Future<void> _onFetchCourses(Emitter<CoursesState> emit) async {
    // This method is deprecated - courses should be accessed via learning paths
    // For now, emit an error state
    if (!emit.isDone) {
      emit(
        state.copyWith(
          vocabularies: const VocabulariesState.error(
            'This feature is deprecated. Please access courses through learning paths.',
          ),
          phrases: const PhrasesState.error(
            'This feature is deprecated. Please access courses through learning paths.',
          ),
        ),
      );
    }
  }

  /// Placeholder method for getUserPreferences event
  /// This should not be called anymore as user info is in learning paths
  Future<void> _onGetUserPreferences(Emitter<CoursesState> emit) async {
    // This method is deprecated - user info is now in learning paths
    // For now, emit an error state
    if (!emit.isDone) {
      emit(
        state.copyWith(
          userPreferences: const UserPreferencesState.error(
            'This feature is deprecated. User info is in learning paths.',
          ),
        ),
      );
    }
  }

  /// Refreshes all courses content
  /// Currently disabled as courses are accessed through learning paths
  Future<void> _onRefreshLessons(Emitter<CoursesState> emit) async {
    // Disabled for now
  }

  /// Fetches lessons with course context for personalized content
  /// Generates content specific to the course and learning path
  /// This method checks for existing course content first, then generates new if needed
  Future<void> _onFetchLessonsWithCourseContext(
    Emitter<CoursesState> emit,
    String pathId,
    int courseNumber,
    LearningPath learningPath,
  ) async {
    if (!emit.isDone) {
      emit(
        state.copyWith(
          vocabularies: const VocabulariesState.loading(),
          phrases: const PhrasesState.loading(),
          isRefreshing: true,
        ),
      );
    }

    try {
      // Use the courses repository to get course-specific content
      final result = await coursesRepository.getCourseLessons(
        pathId,
        courseNumber,
        learningPath,
      );

      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                vocabularies: VocabulariesState.error(failure.message),
                phrases: PhrasesState.error(failure.message),
                isRefreshing: false,
              ),
            );
          }
        },
        (data) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                vocabularies: VocabulariesState.loaded(data.vocabularies),
                phrases: PhrasesState.loaded(data.phrases),
                isRefreshing: false,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(
          state.copyWith(
            vocabularies: VocabulariesState.error(e.toString()),
            phrases: PhrasesState.error(e.toString()),
            isRefreshing: false,
          ),
        );
      }
    }
  }

  /// Handles course completion
  /// Completes the course and unlocks the next one in the learning path
  Future<void> _onCompleteCourse(
    Emitter<CoursesState> emit,
    String pathId,
    int courseNumber,
  ) async {
    if (!emit.isDone) {
      emit(
        state.copyWith(courseCompletion: const CourseCompletionState.loading()),
      );
    }

    try {
      final result = await completeCourseUseCase(pathId, courseNumber);

      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                courseCompletion: CourseCompletionState.error(failure.message),
              ),
            );
          }
        },
        (_) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                courseCompletion: CourseCompletionState.completed(
                  pathId: pathId,
                  courseNumber: courseNumber,
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(
          state.copyWith(
            courseCompletion: CourseCompletionState.error(e.toString()),
          ),
        );
      }
    }
  }
}
