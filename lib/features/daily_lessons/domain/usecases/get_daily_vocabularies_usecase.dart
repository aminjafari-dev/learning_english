// get_daily_vocabularies_usecase.dart
// Use case for fetching daily vocabularies, extends the base UseCase class.
// Updated to use personalized content based on user preferences.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/core/error/failure.dart';
import '../entities/vocabulary.dart';
import '../entities/user_preferences.dart';
import '../repositories/daily_lessons_repository.dart';

/// Use case for getting daily vocabularies
/// Now uses personalized content based on user preferences
class GetDailyVocabulariesUseCase
    extends UseCase<List<Vocabulary>, UserPreferences> {
  final DailyLessonsRepository repository;

  /// Inject the repository via constructor
  GetDailyVocabulariesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Vocabulary>>> call(
    UserPreferences preferences,
  ) async {
    // Get personalized lessons and extract only vocabularies
    final result = await repository.getPersonalizedDailyLessons(preferences);
    return result.fold(
      (failure) => left(failure),
      (data) => right(data.vocabularies),
    );
  }
}

// Example usage:
// final useCase = GetDailyVocabulariesUseCase(repo);
// final preferences = UserPreferences(level: Level.intermediate, focusAreas: ['business']);
// final result = await useCase(preferences);
