// daily_lessons_repository.dart
// Abstract repository interface for the Daily Lessons feature.
// This interface defines the contract for fetching vocabularies and phrases.
// Now includes user-specific data management and analytics methods.

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/vocabulary.dart';
import '../entities/phrase.dart';
import '../../data/datasources/ai_provider_type.dart';

/// Abstract repository for daily lessons with user-specific storage
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
  /// Includes user-specific storage and retrieval logic
  Future<
    Either<Failure, ({List<Vocabulary> vocabularies, List<Phrase> phrases})>
  >
  getDailyLessons();

  /// Refreshes all daily lesson content
  Future<Either<Failure, bool>> refreshDailyLessons();

  /// Marks vocabulary as used for the current user
  /// Updates the usage status in local storage to avoid suggesting the same content again
  Future<Either<Failure, bool>> markVocabularyAsUsed(String english);

  /// Marks phrase as used for the current user
  /// Updates the usage status in local storage to avoid suggesting the same content again
  Future<Either<Failure, bool>> markPhraseAsUsed(String english);

  /// Gets analytics data for the current user
  /// Returns usage statistics and cost analysis by AI provider
  Future<Either<Failure, Map<String, dynamic>>> getUserAnalytics();

  /// Gets vocabulary data by AI provider for the current user
  /// Used for analyzing performance and cost by provider
  Future<Either<Failure, List<Vocabulary>>> getVocabulariesByProvider(
    AiProviderType provider,
  );

  /// Gets phrase data by AI provider for the current user
  /// Used for analyzing performance and cost by provider
  Future<Either<Failure, List<Phrase>>> getPhrasesByProvider(
    AiProviderType provider,
  );

  /// Clears all data for the current user
  /// Used when user wants to reset their learning progress
  Future<Either<Failure, bool>> clearUserData();
}

// Example usage:
// final repo = ... // get from DI
// final vocabResult = await repo.getDailyVocabularies();
// final phraseResult = await repo.getDailyPhrases();
// final lessonsResult = await repo.getDailyLessons(); // More cost-effective
// await repo.markVocabularyAsUsed('Perseverance');
// final analytics = await repo.getUserAnalytics();
