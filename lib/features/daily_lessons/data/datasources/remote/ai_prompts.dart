// ai_prompts.dart
// Centralized AI prompts for the Daily Lessons feature.
// This class contains personalized prompts based on user preferences.
// All prompts are now personalized to provide better learning experience.
//
// Usage:
//   final preferences = UserPreferences(level: Level.intermediate, focusAreas: ['business', 'travel']);
//   final personalizedVocabPrompt = AiPrompts.getPersonalizedVocabularySystemPrompt(preferences);
//   final personalizedPhrasePrompt = AiPrompts.getPersonalizedPhraseSystemPrompt(preferences);
//   final personalizedLessonsPrompt = AiPrompts.getPersonalizedLessonsSystemPrompt(preferences);

import '../../../domain/entities/user_preferences.dart';

/// Centralized AI prompts for Daily Lessons feature
/// This class provides personalized prompts based on user preferences
class AiPrompts {
  static const String promptVersion = '1.0.0';

  /// Gets personalized vocabulary system prompt based on user preferences
  /// Creates level-appropriate and focus-specific vocabulary prompts
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  ///
  /// Returns: Personalized system prompt for vocabulary generation
  static String getPersonalizedVocabularySystemPrompt(
    UserPreferences preferences,
  ) {
    final levelDesc = preferences.levelDescription;
    final focusAreas = preferences.focusAreasString;

    return '''You are an English teacher specializing in $levelDesc level English. 
Provide a list of 4 useful English vocabulary words suitable for $levelDesc level learners, 
focused on these areas: $focusAreas. Each word should be practical and commonly used in these contexts.
Respond in JSON format: [{"english": "...", "persian": "..."}, ...]''';
  }

  /// Gets personalized vocabulary user prompt based on user preferences
  /// Creates level-appropriate and focus-specific vocabulary requests
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  ///
  /// Returns: Personalized user prompt for vocabulary requests
  static String getPersonalizedVocabularyUserPrompt(
    UserPreferences preferences,
  ) {
    final levelDesc = preferences.levelDescription;
    final focusAreas = preferences.focusAreasString;

    return 'Give me 4 $levelDesc level English vocabulary words focused on $focusAreas, with Persian translations.';
  }

  /// Gets personalized phrase system prompt based on user preferences
  /// Creates level-appropriate and focus-specific phrase prompts
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  ///
  /// Returns: Personalized system prompt for phrase generation
  static String getPersonalizedPhraseSystemPrompt(UserPreferences preferences) {
    final levelDesc = preferences.levelDescription;
    final focusAreas = preferences.focusAreasString;

    return '''You are an English teacher specializing in $levelDesc level English. 
Provide a list of 2 useful English phrases suitable for $levelDesc level learners, 
focused on these areas: $focusAreas. Each phrase should be practical and commonly used in these contexts.
Respond in JSON format: [{"english": "...", "persian": "..."}, ...]''';
  }

  /// Gets personalized phrase user prompt based on user preferences
  /// Creates level-appropriate and focus-specific phrase requests
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  ///
  /// Returns: Personalized user prompt for phrase requests
  static String getPersonalizedPhraseUserPrompt(UserPreferences preferences) {
    final levelDesc = preferences.levelDescription;
    final focusAreas = preferences.focusAreasString;

    return 'Give me 2 $levelDesc level English phrases focused on $focusAreas, with Persian translations.';
  }

  /// Gets personalized lessons system prompt based on user preferences
  /// Creates level-appropriate and focus-specific combined lessons prompts
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  ///
  /// Returns: Personalized system prompt for combined lessons generation
  static String getPersonalizedLessonsSystemPrompt(
    UserPreferences preferences,
  ) {
    final levelDesc = preferences.levelDescription;
    final focusAreas = preferences.focusAreasString;

    return '''You are an English teacher specializing in $levelDesc level English. 
Provide both vocabulary words and phrases suitable for $levelDesc level learners, 
focused on these areas: $focusAreas. Each item should be practical and commonly used in these contexts.
Respond in JSON format with two arrays: vocabularies and phrases. 
Format: {"vocabularies": [{"english": "...", "persian": "..."}], "phrases": [{"english": "...", "persian": "..."}]}''';
  }

  /// Gets personalized lessons user prompt based on user preferences
  /// Creates level-appropriate and focus-specific combined lessons requests
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  ///
  /// Returns: Personalized user prompt for combined lessons requests
  static String getPersonalizedLessonsUserPrompt(UserPreferences preferences) {
    final levelDesc = preferences.levelDescription;
    final focusAreas = preferences.focusAreasString;

    return 'Give me 4 $levelDesc level English vocabulary words and 2 $levelDesc level English phrases, all focused on $focusAreas, with Persian translations.';
  }

  /// Gets all personalized prompts for a given user preference
  /// Returns a map containing all personalized prompts
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  ///
  /// Returns: Map containing all personalized prompts
  static Map<String, String> getAllPersonalizedPrompts(
    UserPreferences preferences,
  ) {
    return {
      'vocabularySystem': getPersonalizedVocabularySystemPrompt(preferences),
      'vocabularyUser': getPersonalizedVocabularyUserPrompt(preferences),
      'phraseSystem': getPersonalizedPhraseSystemPrompt(preferences),
      'phraseUser': getPersonalizedPhraseUserPrompt(preferences),
      'lessonsSystem': getPersonalizedLessonsSystemPrompt(preferences),
      'lessonsUser': getPersonalizedLessonsUserPrompt(preferences),
    };
  }
}

// Example usage:
// final preferences = UserPreferences(
//   level: Level.intermediate,
//   focusAreas: ['business', 'travel', 'social']
// );
// final personalizedVocabPrompt = AiPrompts.getPersonalizedVocabularySystemPrompt(preferences);
// final personalizedPhrasePrompt = AiPrompts.getPersonalizedPhraseSystemPrompt(preferences);
// final personalizedLessonsPrompt = AiPrompts.getPersonalizedLessonsSystemPrompt(preferences);
// final allPersonalizedPrompts = AiPrompts.getAllPersonalizedPrompts(preferences);
