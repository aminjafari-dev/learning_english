// courses_bloc.dart
// Bloc for managing courses operations.
// Generates personalized lessons based on user preferences.
// Now includes user-specific data management and analytics functionality.
// Now supports personalized content generation based on user preferences.

import 'package:bloc/bloc.dart';
import 'courses_event.dart';
import 'courses_state.dart';
import '../../domain/usecases/get_courses_usecase.dart';
import '../../domain/usecases/get_user_preferences_usecase.dart';
import '../../domain/usecases/complete_course_usecase.dart';
import '../../domain/repositories/courses_repository.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/features/learning_paths/domain/entities/learning_path.dart';

/// Bloc for managing courses (vocabularies and phrases)
/// Generates personalized lessons based on user preferences
/// Includes user-specific data management and analytics functionality
/// Supports personalized content generation based on user preferences
class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final GetCoursesUseCase getCoursesUseCase;
  final GetUserPreferencesUseCase getUserPreferencesUseCase;
  final CompleteCourseUseCase completeCourseUseCase;
  final CoursesRepository coursesRepository;

  CoursesBloc({
    required this.getCoursesUseCase,
    required this.getUserPreferencesUseCase,
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
        fetchLessons:
            () => _onFetchCourses(
              emit,
            ), // Fetch courses
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

  /// Fetches personalized courses based on user preferences
  /// This method generates new vocabularies and phrases using AI
  /// Generated content is automatically saved to local storage for tracking
  Future<void> _onFetchCourses(
    Emitter<CoursesState> emit,
  ) async {
    try {
      if (!emit.isDone) {
        emit(
          state.copyWith(
            vocabularies: const VocabulariesState.loading(),
            phrases: const PhrasesState.loading(),
            userPreferences: const UserPreferencesState.loading(),
            courseCompletion: const CourseCompletionState.initial(),
            isRefreshing: true,
          ),
        );
      }

      // First get user preferences
      final preferencesResult = await getUserPreferencesUseCase(NoParams());
      final preferences = preferencesResult.fold((failure) {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              vocabularies: VocabulariesState.error(
                'Failed to get user preferences: ${failure.message}',
              ),
              phrases: PhrasesState.error(
                'Failed to get user preferences: ${failure.message}',
              ),
              userPreferences: UserPreferencesState.error(
                'Failed to get user preferences: ${failure.message}',
              ),
              isRefreshing: false,
            ),
          );
        }
        return null;
      }, (preferences) => preferences);

      if (preferences == null) return;

      // Emit user preferences state
      if (!emit.isDone) {
        emit(
          state.copyWith(
            userPreferences: UserPreferencesState.loaded(preferences),
          ),
        );
      }

      // Then fetch courses using the preferences
      final result = await getCoursesUseCase(preferences);
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
            vocabularies: VocabulariesState.error(
              'Failed to fetch courses: ${e.toString()}',
            ),
            phrases: PhrasesState.error(
              'Failed to fetch courses: ${e.toString()}',
            ),
            isRefreshing: false,
          ),
        );
      }
    }
  }

  /// Gets user preferences for personalized content generation
  /// Returns user's level and selected learning focus areas
  Future<void> _onGetUserPreferences(Emitter<CoursesState> emit) async {
    try {
      if (!emit.isDone) {
        emit(
          state.copyWith(userPreferences: const UserPreferencesState.loading()),
        );
      }

      final result = await getUserPreferencesUseCase(NoParams());
      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                userPreferences: UserPreferencesState.error(failure.message),
              ),
            );
          }
        },
        (preferences) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                userPreferences: UserPreferencesState.loaded(preferences),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(
          state.copyWith(
            userPreferences: UserPreferencesState.error(e.toString()),
          ),
        );
      }
    }
  }

  /// Refreshes all courses content
  /// Clears local cache and fetches fresh content from conversation
  Future<void> _onRefreshLessons(Emitter<CoursesState> emit) async {
    add(const CoursesEvent.fetchLessons());
  }

  /// Fetches lessons with course context for personalized content
  /// Generates content specific to the course, learning path, and user preferences
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
          userPreferences: const UserPreferencesState.loading(),
          courseCompletion: const CourseCompletionState.initial(),
          isRefreshing: true,
        ),
      );
    }

    try {
      // First get user preferences
      final preferencesResult = await getUserPreferencesUseCase(NoParams());
      final basePreferences = preferencesResult.fold((failure) {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              vocabularies: VocabulariesState.error(
                'Failed to get user preferences: ${failure.message}',
              ),
              phrases: PhrasesState.error(
                'Failed to get user preferences: ${failure.message}',
              ),
              userPreferences: UserPreferencesState.error(
                'Failed to get user preferences: ${failure.message}',
              ),
              isRefreshing: false,
            ),
          );
        }
        return null;
      }, (preferences) => preferences);

      if (basePreferences == null) return;

      // Emit user preferences state
      if (!emit.isDone) {
        emit(
          state.copyWith(
            userPreferences: UserPreferencesState.loaded(basePreferences),
          ),
        );
      }

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
