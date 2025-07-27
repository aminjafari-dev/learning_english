// get_daily_phrases_usecase.dart
// Use case for fetching daily phrases, extends the base UseCase class.
// Updated to use personalized content based on user preferences.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/core/error/failure.dart';
import '../entities/phrase.dart';
import '../entities/user_preferences.dart';
import '../repositories/daily_lessons_repository.dart';

/// Use case for getting daily phrases
/// Now uses personalized content based on user preferences
class GetDailyPhrasesUseCase extends UseCase<List<Phrase>, UserPreferences> {
  final DailyLessonsRepository repository;

  /// Inject the repository via constructor
  GetDailyPhrasesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Phrase>>> call(
    UserPreferences preferences,
  ) async {
    // Get personalized lessons and extract only phrases
    final result = await repository.getPersonalizedDailyLessons(preferences);
    return result.fold(
      (failure) => left(failure),
      (data) => right(data.phrases),
    );
  }
}

// Example usage:
// final useCase = GetDailyPhrasesUseCase(repo);
// final preferences = UserPreferences(level: Level.intermediate, focusAreas: ['business']);
// final result = await useCase(preferences);
