// conversation_prompts.dart
// Conversation prompts for the Daily Lessons feature.
// This class provides prompts that help avoid repetitive content by considering user's learning history.
// All prompts are designed to suggest fresh, non-repetitive learning material.
//
// Usage:
//   final prompts = ConversationPrompts();
//   final lessonPrompt = prompts.getLessonPrompt(preferences, usedVocabularies, usedPhrases);
//   final conversationPrompt = prompts.getConversationPrompt(preferences, context);

import '../../../domain/entities/user_preferences.dart';
import '../../models/vocabulary_model.dart';
import '../../models/phrase_model.dart';

/// Conversation prompts for Daily Lessons feature
/// This class provides prompts that help avoid repetitive content
class ConversationPrompts {
  static const String promptVersion = '2.0.0';

  /// Gets a lesson prompt that asks for new vocabularies and phrases
  /// Avoids repetitive content by considering user's learning history
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  /// - usedVocabularies: List of vocabularies the user has already learned
  /// - usedPhrases: List of phrases the user has already learned
  ///
  /// Returns: Prompt that asks for fresh learning material
  static String getLessonPrompt(
    UserPreferences preferences,
    List<VocabularyModel> usedVocabularies,
    List<PhraseModel> usedPhrases,
  ) {
    final levelDesc = preferences.levelDescription;
    final focusAreas = preferences.focusAreasString;

    // Create list of already learned words to avoid repetition
    final learnedWords =
        usedVocabularies.map((v) => v.english.toLowerCase()).toSet();
    final learnedPhrases =
        usedPhrases.map((p) => p.english.toLowerCase()).toSet();

    final learnedWordsList = learnedWords
        .take(20)
        .join(', '); // Show last 20 words
    final learnedPhrasesList = learnedPhrases
        .take(10)
        .join(', '); // Show last 10 phrases

    return '''You are an English teacher helping me learn new vocabulary and phrases. 
I'm at $levelDesc level and I want to focus on $focusAreas.

IMPORTANT REQUIREMENTS:
1. Suggest ONLY NEW words and phrases that I haven't learned before
2. I have already learned these words: $learnedWordsList
3. I have already learned these phrases: $learnedPhrasesList
4. Make suggestions practical and useful for my level
5. Include Persian translations
6. Format response as JSON with "vocabularies" and "phrases" arrays

Please suggest 5 new vocabulary words and 3 new phrases that are:
- Different from what I've already learned
- Appropriate for my $levelDesc level
- Focused on $focusAreas
- Practical and commonly used

Format your response exactly like this:
{
  "vocabularies": [
    {"english": "new_word1", "persian": "ترجمه1"},
    {"english": "new_word2", "persian": "ترجمه2"}
  ],
  "phrases": [
    {"english": "new_phrase1", "persian": "ترجمه1"},
    {"english": "new_phrase2", "persian": "ترجمه2"}
  ]
}''';
  }

  /// Gets a conversation prompt for interactive learning
  /// Creates engaging conversation prompts based on user preferences
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  /// - context: Current conversation context
  ///
  /// Returns: Interactive conversation prompt
  static String getConversationPrompt(
    UserPreferences preferences,
    String context,
  ) {
    final levelDesc = preferences.levelDescription;
    final focusAreas = preferences.focusAreasString;

    return '''You are an English conversation partner for a $levelDesc level learner.
The learner wants to focus on $focusAreas topics.

Current conversation context: $context

Please:
1. Respond naturally and conversationally
2. Use vocabulary appropriate for $levelDesc level
3. Focus on $focusAreas topics when relevant
4. Help the learner practice English in a friendly way
5. Correct mistakes gently and provide explanations when helpful
6. Keep responses engaging but not too long

Remember: You're having a natural conversation, not teaching a formal lesson.''';
  }

  /// Gets a practice prompt for specific topics
  /// Creates focused practice prompts for particular learning areas
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  /// - topic: Specific topic to practice
  ///
  /// Returns: Topic-specific practice prompt
  static String getPracticePrompt(UserPreferences preferences, String topic) {
    final levelDesc = preferences.levelDescription;

    return '''Let's practice English related to "$topic" at $levelDesc level.

Please:
1. Ask me questions about $topic
2. Use vocabulary and phrases related to $topic
3. Help me practice speaking about $topic
4. Correct my mistakes gently
5. Provide explanations when needed
6. Keep the conversation engaging and natural

Let's start with a simple question about $topic.''';
  }

  /// Gets a vocabulary review prompt
  /// Creates prompts for reviewing previously learned vocabulary
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  /// - vocabularies: List of vocabularies to review
  ///
  /// Returns: Review prompt
  static String getReviewPrompt(
    UserPreferences preferences,
    List<VocabularyModel> vocabularies,
  ) {
    final levelDesc = preferences.levelDescription;
    final vocabList = vocabularies.take(10).map((v) => v.english).join(', ');

    return '''Let's review some vocabulary I've learned: $vocabList

I'm at $levelDesc level. Please:
1. Ask me to use these words in sentences
2. Test my understanding of their meanings
3. Help me practice pronunciation
4. Provide context for when to use each word
5. Correct any mistakes I make
6. Make the review engaging and interactive

Let's start with the first word: ${vocabularies.first.english}''';
  }

  /// Gets a conversation starter prompt
  /// Creates engaging conversation starters based on user preferences
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  ///
  /// Returns: Conversation starter prompt
  static String getConversationStarter(UserPreferences preferences) {
    final levelDesc = preferences.levelDescription;
    final focusAreas = preferences.focusAreasString;

    return '''Hi! I'm here to help you practice English at $levelDesc level.
I know you're interested in $focusAreas topics.

Let's have a natural conversation! You can:
- Ask me questions
- Tell me about your day
- Practice talking about $focusAreas
- Ask for vocabulary or phrases
- Practice pronunciation

What would you like to talk about today?''';
  }

  /// Gets all conversation prompts for a given user preference
  /// Returns a map containing all conversation prompts
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas
  /// - usedVocabularies: User's learned vocabularies
  /// - usedPhrases: User's learned phrases
  ///
  /// Returns: Map containing all conversation prompts
  static Map<String, String> getAllPrompts(
    UserPreferences preferences,
    List<VocabularyModel> usedVocabularies,
    List<PhraseModel> usedPhrases,
  ) {
    return {
      'lesson': getLessonPrompt(preferences, usedVocabularies, usedPhrases),
      'conversation': getConversationPrompt(preferences, 'general'),
      'practice': getPracticePrompt(preferences, preferences.focusAreas.first),
      'review': getReviewPrompt(preferences, usedVocabularies),
      'starter': getConversationStarter(preferences),
    };
  }
}

// Example usage:
// final preferences = UserPreferences(
//   level: Level.intermediate,
//   focusAreas: ['business', 'technology']
// );
// final usedVocabularies = await localDataSource.getUserVocabularies('user123');
// final usedPhrases = await localDataSource.getUserPhrases('user123');
// 
// final lessonPrompt = ConversationPrompts.getLessonPrompt(preferences, usedVocabularies, usedPhrases);
// final conversationPrompt = ConversationPrompts.getConversationPrompt(preferences, 'general');
// final allPrompts = ConversationPrompts.getAllPrompts(preferences, usedVocabularies, usedPhrases); 