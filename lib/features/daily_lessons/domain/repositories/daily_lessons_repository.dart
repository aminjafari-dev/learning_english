// daily_lessons_repository.dart
// Abstract repository interface for the Daily Lessons feature.
// This interface defines the contract for fetching vocabularies and phrases.

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/vocabulary.dart';
import '../entities/phrase.dart';

/// Abstract repository for daily lessons
abstract class DailyLessonsRepository {
  /// Fetches daily vocabularies
  /// @deprecated Use getDailyLessons() instead for better cost efficiency
  Future<Either<Failure, List<Vocabulary>>> getDailyVocabularies();

  /// Fetches daily phrases
  /// @deprecated Use getDailyLessons() instead for better cost efficiency
  Future<Either<Failure, List<Phrase>>> getDailyPhrases();

  /// Fetches both daily vocabularies and phrases in a single request
  /// This method is more cost-effective than making separate requests
  /// Returns a tuple containing vocabularies and phrases
  Future<
    Either<Failure, ({List<Vocabulary> vocabularies, List<Phrase> phrases})>
  >
  getDailyLessons();

  /// Refreshes all daily lesson content
  Future<Either<Failure, bool>> refreshDailyLessons();
}

// Example usage:
// final repo = ... // get from DI
// final vocabResult = await repo.getDailyVocabularies();
// final phraseResult = await repo.getDailyPhrases();
// final lessonsResult = await repo.getDailyLessons(); // More cost-effective
