// daily_lessons_repository.dart
// Abstract repository interface for the Daily Lessons feature.
// All methods are now personalized based on user preferences.
// This interface defines the contract for fetching personalized vocabularies and phrases.

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/vocabulary.dart';
import '../entities/phrase.dart';
import '../entities/ai_usage_metadata.dart';
import '../entities/user_preferences.dart';
import '../../data/datasources/ai_provider_type.dart';

/// Abstract repository for daily lessons with personalized content
abstract class DailyLessonsRepository {
  /// Fetches personalized daily lessons based on user preferences
  /// Creates level-appropriate and focus-specific content
  /// This method is more cost-effective than making separate requests
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  ///
  /// Returns: Either Failure or tuple containing personalized vocabularies, phrases, and metadata
  Future<
    Either<
      Failure,
      ({
        List<Vocabulary> vocabularies,
        List<Phrase> phrases,
        AiUsageMetadata metadata,
      })
    >
  >
  getPersonalizedDailyLessons(UserPreferences preferences);

  /// Fetches user preferences (level and focus areas) for personalized content
  /// Combines data from level selection and learning focus selection features
  /// Returns default preferences if user data is not available
  ///
  /// Returns: Either Failure or UserPreferences
  Future<Either<Failure, UserPreferences>> getUserPreferences();

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
// 
// // Personalized content
// final preferences = await repo.getUserPreferences();
// preferences.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (prefs) => {
//     final personalizedResult = await repo.getPersonalizedDailyLessons(prefs);
//   },
// );
// 
// await repo.markVocabularyAsUsed('Perseverance');
// final analytics = await repo.getUserAnalytics();
