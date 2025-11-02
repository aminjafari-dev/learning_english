// get_daily_lessons_usecase.dart
// Use case for getting personalized daily lessons.
// This generates vocabularies and phrases based on user preferences.
// Now saves generated content to local storage for tracking and analytics.
//
// Usage:
// final useCase = GetDailyLessonsUseCase(repository);
// final preferences = UserPreferences(level: Level.intermediate, focusAreas: ['business']);
// final result = await useCase.call(preferences);
// result.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (data) => print('New vocabularies: ${data.vocabularies.length}, New phrases: ${data.phrases.length}'),
// );

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../entities/vocabulary.dart';
import '../entities/phrase.dart';
import '../entities/user_preferences.dart';
import '../repositories/daily_lessons_repository.dart';

/// Use case for getting personalized daily lessons
/// Generates vocabularies and phrases based on user preferences
/// Saves generated content to local storage for tracking and analytics
class GetDailyLessonsUseCase
    implements
        UseCase<
          ({List<Vocabulary> vocabularies, List<Phrase> phrases}),
          UserPreferences
        > {
  final DailyLessonsRepository repository;

  /// Constructor
  /// @param repository Daily lessons repository
  GetDailyLessonsUseCase(this.repository);

  @override
  Future<
    Either<Failure, ({List<Vocabulary> vocabularies, List<Phrase> phrases})>
  >
  call(UserPreferences preferences) async {
    try {
      // Generate personalized lessons based on user preferences
      final result = await repository.getPersonalizedDailyLessons(preferences);

      return result.fold(
        (failure) => left(failure),
        (data) =>
            right((vocabularies: data.vocabularies, phrases: data.phrases)),
      );
    } catch (e) {
      return left(
        ServerFailure('Failed to get daily lessons: ${e.toString()}'),
      );
    }
  }
}

// Example usage:
// final useCase = GetDailyLessonsUseCase(getIt<DailyLessonsRepository>());
// final preferences = UserPreferences(
//   level: Level.intermediate,
//   focusAreas: ['business', 'technology']
// );
// final result = await useCase.call(preferences);
// result.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (data) {
//     print('New vocabularies: ${data.vocabularies.length}');
//     print('New phrases: ${data.phrases.length}');
//   },
// );
