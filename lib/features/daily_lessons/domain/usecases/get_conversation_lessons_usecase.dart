// get_conversation_lessons_usecase.dart
// Use case for getting personalized lessons through conversation mode.
// This replaces the traditional daily lessons to avoid repetitive content.
// The AI suggests new vocabularies and phrases based on conversation context.
// Now saves generated content to local storage for tracking and analytics.
//
// Usage:
// final useCase = GetConversationLessonsUseCase(repository);
// final preferences = UserPreferences(level: Level.intermediate, focusAreas: ['business']);
// final result = await useCase.call(preferences);
// result.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (data) => print('New vocabularies: ${data.vocabularies.length}, New phrases: ${data.phrases.length}'),
// );

import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../entities/vocabulary.dart';
import '../entities/phrase.dart';
import '../entities/user_preferences.dart';
import '../repositories/conversation_repository.dart';
import '../../data/datasources/remote/conversation_prompts.dart';
import '../../data/datasources/local/daily_lessons_local_data_source.dart';
import '../../data/models/learning_request_model.dart';
import '../../data/models/vocabulary_model.dart';
import '../../data/models/phrase_model.dart';
import '../../data/models/ai_provider_type.dart';
import '../../data/models/level_type.dart';
import 'package:learning_english/core/repositories/user_repository.dart'
    as core_user;

/// Use case for getting personalized lessons through conversation mode
/// Replaces traditional daily lessons to avoid repetitive content
/// AI suggests new vocabularies and phrases based on conversation context and user history
/// Now saves generated content to local storage for tracking and analytics
class GetConversationLessonsUseCase
    implements
        UseCase<
          ({
            List<Vocabulary> vocabularies,
            List<Phrase> phrases,
            String conversationContext,
          }),
          UserPreferences
        > {
  final ConversationRepository repository;
  final DailyLessonsLocalDataSource localDataSource;
  final core_user.UserRepository coreUserRepository;

  GetConversationLessonsUseCase(
    this.repository,
    this.localDataSource,
    this.coreUserRepository,
  );

  @override
  Future<
    Either<
      Failure,
      ({
        List<Vocabulary> vocabularies,
        List<Phrase> phrases,
        String conversationContext,
      })
    >
  >
  call(UserPreferences preferences) async {
    try {
      // Get user ID for tracking
      final userId = await coreUserRepository.getUserId() ?? 'current_user';


      // Create a conversation prompt that asks for new vocabularies and phrases
      // This prompt considers user's learning history to avoid repetition
      final conversationPrompt = ConversationPrompts.getLessonPrompt(
        preferences,
      );

      // Send conversation message to get personalized lessons
      final result = await repository.sendConversationMessage(
        preferences,
        conversationPrompt,
      );

      return result.fold((failure) => left(failure), (aiResponse) async {
        // Parse the AI response to extract vocabularies and phrases
        final parsedData = _parseAIResponse(aiResponse);

        // Save the generated content to local storage
        await _saveConversationGeneratedContent(
          userId,
          preferences,
          parsedData.vocabularies,
          parsedData.phrases,
          aiResponse,
        );

        return right((
          vocabularies: parsedData.vocabularies,
          phrases: parsedData.phrases,
          conversationContext: aiResponse,
        ));
      });
    } catch (e) {
      return left(
        ServerFailure('Failed to get conversation lessons: ${e.toString()}'),
      );
    }
  }

  /// Saves conversation-generated content to local storage
  /// Creates a learning request with conversation context for proper tracking
  Future<void> _saveConversationGeneratedContent(
    String userId,
    UserPreferences preferences,
    List<Vocabulary> vocabularies,
    List<Phrase> phrases,
    String conversationContext,
  ) async {
    try {
      print('💾 [CONVERSATION] Saving generated content to local storage');
      print(
        '💾 [CONVERSATION] Vocabularies: ${vocabularies.length}, Phrases: ${phrases.length}',
      );

      // Convert domain entities to models for storage
      final vocabularyModels =
          vocabularies
              .map(
                (vocab) => VocabularyModel(
                  english: vocab.english,
                  persian: vocab.persian,
                  isUsed: false,
                ),
              )
              .toList();

      final phraseModels =
          phrases
              .map(
                (phrase) => PhraseModel(
                  english: phrase.english,
                  persian: phrase.persian,
                  isUsed: false,
                ),
              )
              .toList();

      // Create learning request with conversation context
      final learningRequest = LearningRequestModel(
        requestId: 'conversation_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        userLevel: _convertToModelUserLevel(preferences.level),
        focusAreas: preferences.focusAreas,
        aiProvider: AiProviderType.gemini, // Conversation uses Gemini
        aiModel: 'gemini-1.5-flash',
        totalTokensUsed: 0, // Will be updated if available
        estimatedCost: 0.0, // Will be updated if available
        requestTimestamp: DateTime.now(),
        createdAt: DateTime.now(),
        systemPrompt: 'Conversation mode lesson generation',
        userPrompt: conversationContext.substring(
          0,
          conversationContext.length > 200 ? 200 : conversationContext.length,
        ),
        vocabularies: vocabularyModels,
        phrases: phraseModels,
        metadata: {
          'source': 'conversation_mode',
          'preferences': {
            'level': preferences.level.name,
            'focusAreas': preferences.focusAreas,
          },
          'conversationContext': conversationContext.substring(
            0,
            conversationContext.length > 200 ? 200 : conversationContext.length,
          ),
        },
      );

      // Save to local storage
      await localDataSource.saveLearningRequest(learningRequest);
      print(
        '✅ [CONVERSATION] Successfully saved conversation-generated content',
      );
    } catch (e) {
      print(
        '❌ [CONVERSATION] Failed to save conversation-generated content: $e',
      );
      // Don't throw here to avoid breaking the main flow
    }
  }

  /// Parses AI response to extract vocabularies and phrases
  /// Handles JSON parsing and validation
  ({List<Vocabulary> vocabularies, List<Phrase> phrases}) _parseAIResponse(
    String aiResponse,
  ) {
    try {
      // Extract JSON from the response (AI might add extra text)
      final jsonStart = aiResponse.indexOf('{');
      final jsonEnd = aiResponse.lastIndexOf('}') + 1;

      if (jsonStart == -1 || jsonEnd == 0) {
        throw Exception('No JSON found in AI response');
      }

      final jsonString = aiResponse.substring(jsonStart, jsonEnd);
      final Map<String, dynamic> data = jsonDecode(jsonString);

      // Parse vocabularies
      final List<dynamic> vocabList = data['vocabularies'] ?? [];
      final vocabularies =
          vocabList
              .map(
                (e) => Vocabulary(
                  english: e['english'] ?? '',
                  persian: e['persian'] ?? '',
                ),
              )
              .where((v) => v.english.isNotEmpty && v.persian.isNotEmpty)
              .toList();

      // Parse phrases
      final List<dynamic> phraseList = data['phrases'] ?? [];
      final phrases =
          phraseList
              .map(
                (e) => Phrase(
                  english: e['english'] ?? '',
                  persian: e['persian'] ?? '',
                ),
              )
              .where((p) => p.english.isNotEmpty && p.persian.isNotEmpty)
              .toList();

      return (vocabularies: vocabularies, phrases: phrases);
    } catch (e) {
      // Return empty lists if parsing fails
      return (vocabularies: <Vocabulary>[], phrases: <Phrase>[]);
    }
  }

  /// Converts domain UserLevel to model UserLevel for storage
  UserLevel _convertToModelUserLevel(dynamic preferences_level) {
    switch (preferences_level.toString()) {
      case 'UserLevel.beginner':
        return UserLevel.beginner;
      case 'UserLevel.elementary':
        return UserLevel.elementary;
      case 'UserLevel.intermediate':
        return UserLevel.intermediate;
      case 'UserLevel.advanced':
        return UserLevel.advanced;
      default:
        return UserLevel.intermediate; // Default fallback
    }
  }
}

// Example usage:
// final useCase = GetConversationLessonsUseCase(getIt<ConversationRepository>());
// final preferences = UserPreferences(
//   level: Level.intermediate,
//   focusAreas: ['business', 'technology']
// );
// final result = await useCase.call(preferences);
// result.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (data) {
//     print('New vocabularies: ${data.vocabularies.length}');
//     print('New phrases: ${data.phrases.length}');
//     print('Context: ${data.conversationContext}');
//   },
// );
