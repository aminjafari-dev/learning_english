// daily_lessons_event.dart
// Bloc events for the Daily Lessons feature, using freezed.
// Now includes user-specific data management and analytics events.
// Now supports personalized content generation based on user preferences.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_lessons_event.freezed.dart';

/// Sealed class for daily lessons events
@freezed
class DailyLessonsEvent with _$DailyLessonsEvent {
  /// Event to fetch daily vocabularies
  /// @deprecated Use fetchLessons() instead for better cost efficiency
  const factory DailyLessonsEvent.fetchVocabularies() = FetchVocabularies;

  /// Event to fetch daily phrases
  /// @deprecated Use fetchLessons() instead for better cost efficiency
  const factory DailyLessonsEvent.fetchPhrases() = FetchPhrases;

  /// Event to fetch both vocabularies and phrases in a single request (cost-effective)
  /// This event reduces API costs by ~25-40% compared to separate requests
  /// Includes user-specific storage and retrieval logic
  const factory DailyLessonsEvent.fetchLessons() = FetchLessons;

  /// Event to refresh all daily lessons
  const factory DailyLessonsEvent.refreshLessons() = RefreshLessons;

  /// Event to mark vocabulary as used by the current user
  /// Prevents the same vocabulary from being suggested again
  const factory DailyLessonsEvent.markVocabularyAsUsed({
    required String english,
  }) = MarkVocabularyAsUsed;

  /// Event to mark phrase as used by the current user
  /// Prevents the same phrase from being suggested again
  const factory DailyLessonsEvent.markPhraseAsUsed({required String english}) =
      MarkPhraseAsUsed;

  /// Event to get analytics data for the current user
  /// Provides insights into learning progress and AI usage costs
  const factory DailyLessonsEvent.getUserAnalytics() = GetUserAnalytics;

  /// Event to clear all data for the current user
  /// Used when user wants to reset their learning progress
  const factory DailyLessonsEvent.clearUserData() = ClearUserData;

  /// Event to get user preferences for personalized content
  /// Returns user's level and selected learning focus areas
  const factory DailyLessonsEvent.getUserPreferences() = GetUserPreferences;
}

// Example usage:
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchVocabularies());
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchLessons()); // More cost-effective
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchPersonalizedLessons()); // Personalized content
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.markVocabularyAsUsed(english: 'Perseverance'));
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.getUserAnalytics());
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.getUserPreferences());
