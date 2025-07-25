// daily_lessons_event.dart
// Bloc events for the Daily Lessons feature, using freezed.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_lessons_event.freezed.dart';

/// Sealed class for daily lessons events
@freezed
class DailyLessonsEvent with _$DailyLessonsEvent {
  /// Event to fetch daily vocabularies
  const factory DailyLessonsEvent.fetchVocabularies() = FetchVocabularies;

  /// Event to fetch daily phrases
  const factory DailyLessonsEvent.fetchPhrases() = FetchPhrases;

  /// Event to refresh all daily lessons
  const factory DailyLessonsEvent.refreshLessons() = RefreshLessons;
}

// Example usage:
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchVocabularies());
