// ai_lessons_remote_data_source.dart
// Abstract interface for AI-based lessons data sources (OpenAI, Gemini, DeepSeek, etc.)
// Implement this interface for each provider.
// All methods are now personalized based on user preferences.

import 'package:dartz/dartz.dart';
import '../../../domain/entities/vocabulary.dart';
import '../../../domain/entities/phrase.dart';
import '../../../domain/entities/ai_usage_metadata.dart';
import '../../../domain/entities/user_preferences.dart';
import 'package:learning_english/core/error/failure.dart';

/// Abstract interface for AI-based lessons data sources
/// All methods are personalized based on user preferences
abstract class AiLessonsRemoteDataSource {
  /// Fetches personalized daily vocabularies based on user preferences
  /// Creates level-appropriate and focus-specific vocabulary content
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  ///
  /// Returns: Either Failure or list of personalized vocabularies
  Future<Either<Failure, List<Vocabulary>>> fetchPersonalizedDailyVocabularies(
    UserPreferences preferences,
  );

  /// Fetches personalized daily phrases based on user preferences
  /// Creates level-appropriate and focus-specific phrase content
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  ///
  /// Returns: Either Failure or list of personalized phrases
  Future<Either<Failure, List<Phrase>>> fetchPersonalizedDailyPhrases(
    UserPreferences preferences,
  );

  /// Fetches personalized daily lessons (vocabularies and phrases) based on user preferences
  /// Creates level-appropriate and focus-specific content in a single request
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
  fetchPersonalizedDailyLessons(UserPreferences preferences);
}
