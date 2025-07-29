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
import '../entities/learning_request.dart' as learning_request;
import '../../data/datasources/ai_provider_type.dart';

/// Abstract repository for daily lessons with personalized content and complete request tracking
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

  /// Gets all vocabularies for the current user from all requests
  /// Returns flattened list of all vocabulary from all user requests
  Future<Either<Failure, List<Vocabulary>>> getUserVocabularies();

  /// Gets all phrases for the current user from all requests
  /// Returns flattened list of all phrases from all user requests
  Future<Either<Failure, List<Phrase>>> getUserPhrases();

  /// Gets all learning requests for the current user
  /// Returns complete request history with all metadata and content
  Future<Either<Failure, List<learning_request.LearningRequest>>>
  getUserRequests();

  /// Gets a specific learning request by ID
  /// Returns the complete request with all metadata and content
  Future<Either<Failure, learning_request.LearningRequest?>> getRequestById(
    String requestId,
  );

  /// Marks vocabulary as used for the current user
  /// Updates the usage status in the specific request
  Future<Either<Failure, Unit>> markVocabularyAsUsed(
    String requestId,
    String english,
  );

  /// Marks phrase as used for the current user
  /// Updates the usage status in the specific request
  Future<Either<Failure, Unit>> markPhraseAsUsed(
    String requestId,
    String english,
  );

  /// Gets analytics data for the current user
  /// Returns usage statistics and cost analysis by AI provider
  Future<Either<Failure, Map<String, dynamic>>> getUserAnalytics();

  /// Clears all data for the current user
  /// Used when user wants to reset their learning progress
  Future<Either<Failure, Unit>> clearUserData();
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
// // Get user's complete request history
// final userRequests = await repo.getUserRequests();
// 
// // Mark content as used
// await repo.markVocabularyAsUsed('requestId', 'Perseverance');
// 
// // Get analytics
// final analytics = await repo.getUserAnalytics();
