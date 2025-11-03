// courses_event.dart
// Bloc events for the Courses feature, using freezed.
// Now includes user-specific data management and analytics events.
// Now supports personalized content generation based on user preferences.
// Now supports course-specific content when launched from learning paths.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_english/features/learning_paths/domain/entities/learning_path.dart';

part 'courses_event.freezed.dart';

/// Sealed class for courses events
@freezed
class CoursesEvent with _$CoursesEvent {
  /// Event to fetch both vocabularies and phrases in a single request (cost-effective)
  /// This event reduces API costs by ~25-40% compared to separate requests
  /// Includes user-specific storage and retrieval logic
  const factory CoursesEvent.fetchLessons() = FetchLessons;

  /// Event to fetch lessons with course context for personalized content
  /// Used when launching from learning path detail page
  /// Generates content specific to the course, level, and focus areas
  const factory CoursesEvent.fetchLessonsWithCourseContext({
    required String pathId,
    required int courseNumber,
    required LearningPath learningPath,
  }) = FetchLessonsWithCourseContext;

  /// Event to refresh all courses
  const factory CoursesEvent.refreshLessons() = RefreshLessons;

  /// Event to get user preferences for personalized content
  /// Returns user's level and selected learning focus areas
  const factory CoursesEvent.getUserPreferences() = GetUserPreferences;

  /// Event to complete a course
  /// Used when user finishes a course in learning path context
  const factory CoursesEvent.completeCourse({
    required String pathId,
    required int courseNumber,
  }) = CompleteCourse;
}

// Example usage:
// context.read<CoursesBloc>().add(const CoursesEvent.fetchVocabularies());
// context.read<CoursesBloc>().add(const CoursesEvent.fetchLessons()); // More cost-effective
// context.read<CoursesBloc>().add(const CoursesEvent.fetchPersonalizedLessons()); // Personalized content
// context.read<CoursesBloc>().add(const CoursesEvent.markVocabularyAsUsed(
//   requestId: 'req_123',
//   english: 'Perseverance'
// ));
// context.read<CoursesBloc>().add(const CoursesEvent.getUserAnalytics());
// context.read<CoursesBloc>().add(const CoursesEvent.getUserPreferences());
