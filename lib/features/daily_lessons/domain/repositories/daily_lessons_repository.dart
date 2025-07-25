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
  Future<Either<Failure, List<Vocabulary>>> getDailyVocabularies();

  /// Fetches daily phrases
  Future<Either<Failure, List<Phrase>>> getDailyPhrases();

  /// Refreshes all daily lesson content
  Future<Either<Failure, bool>> refreshDailyLessons();
}

// Example usage:
// final repo = ... // get from DI
// final vocabResult = await repo.getDailyVocabularies();
// final phraseResult = await repo.getDailyPhrases();
