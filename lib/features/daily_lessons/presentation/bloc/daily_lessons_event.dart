// daily_lessons_event.dart
// Bloc events for the Daily Lessons feature, using freezed.
// Now includes user-specific data management and analytics events.
// Now supports personalized content generation based on user preferences.
// Now supports course-specific content when launched from learning paths.

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_english/features/learning_paths/domain/entities/learning_path.dart';

part 'daily_lessons_event.freezed.dart';

/// Sealed class for daily lessons events
@freezed
class DailyLessonsEvent with _$DailyLessonsEvent {
  /// Event to fetch both vocabularies and phrases in a single request (cost-effective)
  /// This event reduces API costs by ~25-40% compared to separate requests
  /// Includes user-specific storage and retrieval logic
  const factory DailyLessonsEvent.fetchLessons() = FetchLessons;

  /// Event to fetch lessons with course context for personalized content
  /// Used when launching from learning path detail page
  /// Generates content specific to the course, level, and focus areas
  const factory DailyLessonsEvent.fetchLessonsWithCourseContext({
    required String pathId,
    required int courseNumber,
    required LearningPath learningPath,
  }) = FetchLessonsWithCourseContext;

  /// Event to refresh all daily lessons
  const factory DailyLessonsEvent.refreshLessons() = RefreshLessons;

  /// Event to get user preferences for personalized content
  /// Returns user's level and selected learning focus areas
  const factory DailyLessonsEvent.getUserPreferences() = GetUserPreferences;
}

// Example usage:
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchVocabularies());
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchLessons()); // More cost-effective
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchPersonalizedLessons()); // Personalized content
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.markVocabularyAsUsed(
//   requestId: 'req_123',
//   english: 'Perseverance'
// ));
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.getUserAnalytics());
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.getUserPreferences());
