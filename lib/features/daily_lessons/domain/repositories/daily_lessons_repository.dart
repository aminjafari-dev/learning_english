// daily_lessons_repository.dart
// Repository interface for core daily lessons functionality.
// This repository focuses solely on fetching personalized daily lessons from AI providers.
// All other responsibilities have been separated into dedicated repositories.

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/vocabulary.dart';
import '../entities/phrase.dart';
import '../entities/ai_usage_metadata.dart';
import '../entities/user_preferences.dart';

/// Repository interface for core daily lessons functionality
/// Handles only the primary lesson generation and AI interaction
/// Other responsibilities moved to UserPreferencesRepository, UserDataRepository, and ConversationRepository
abstract class DailyLessonsRepository {
  /// Fetches personalized daily lessons based on user preferences
  /// Creates level-appropriate and focus-specific content from AI providers
  /// This is the core method that generates personalized learning content
  ///
  /// This method:
  /// 1. Takes user preferences as input (level and focus areas)
  /// 2. Calls AI service to generate personalized content
  /// 3. Returns vocabularies, phrases, and usage metadata
  /// 4. Handles AI provider selection and optimization
  /// 5. Manages request tracking and cost estimation
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas for content personalization
  ///
  /// Returns: Either Failure or tuple containing:
  /// - vocabularies: List of personalized vocabulary items
  /// - phrases: List of personalized phrases
  /// - metadata: AI usage information (tokens, cost, provider)
  ///
  /// Example usage:
  /// ```dart
  /// final preferences = UserPreferences(
  ///   level: UserLevel.intermediate,
  ///   focusAreas: ['business', 'technology']
  /// );
  ///
  /// final result = await dailyLessonsRepository.getPersonalizedDailyLessons(preferences);
  /// result.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (data) => {
  ///     print('Generated ${data.vocabularies.length} vocabularies'),
  ///     print('Generated ${data.phrases.length} phrases'),
  ///     print('Tokens used: ${data.metadata.totalTokens}')
  ///   },
  /// );
  /// ```
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

}

// Example usage:
// final repo = ... // get from DI
// 
// // Generate personalized content
// final preferences = UserPreferences(level: UserLevel.advanced, focusAreas: ['medical']);
// final personalizedResult = await repo.getPersonalizedDailyLessons(preferences);
// 
// // Validate preferences
// final validationResult = await repo.validateUserPreferences(preferences);
// 
// // Check available providers
// final providers = await repo.getAvailableAiProviders();
// 
// // Estimate cost
// final cost = await repo.estimateLessonGenerationCost(preferences);