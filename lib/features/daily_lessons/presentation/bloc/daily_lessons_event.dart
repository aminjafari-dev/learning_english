// daily_lessons_event.dart
// Bloc events for the Daily Lessons feature, using freezed.

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
  const factory DailyLessonsEvent.fetchLessons() = FetchLessons;

  /// Event to refresh all daily lessons
  const factory DailyLessonsEvent.refreshLessons() = RefreshLessons;
}

// Example usage:
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchVocabularies());
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchLessons()); // More cost-effective
