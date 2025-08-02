// get_conversation_lessons_usecase.dart
// Use case for getting personalized lessons through conversation mode.
// This replaces the traditional daily lessons to avoid repetitive content.
// The AI suggests new vocabularies and phrases based on conversation context.
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
import 'package:learning_english/core/repositories/user_repository.dart'
    as core_user;

/// Use case for getting personalized lessons through conversation mode
/// Replaces traditional daily lessons to avoid repetitive content
/// AI suggests new vocabularies and phrases based on conversation context and user history
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

      // Get user's learning history to avoid repetitive content
      final usedVocabularies = await localDataSource.getUserVocabularies(
        userId,
      );
      final usedPhrases = await localDataSource.getUserPhrases(userId);

      // Create a conversation prompt that asks for new vocabularies and phrases
      // This prompt considers user's learning history to avoid repetition
      final conversationPrompt = ConversationPrompts.getLessonPrompt(
        preferences,
        usedVocabularies,
        usedPhrases,
      );

      // Send conversation message to get personalized lessons
      final result = await repository.sendConversationMessage(
        preferences,
        conversationPrompt,
      );

      return result.fold((failure) => left(failure), (aiResponse) {
        // Parse the AI response to extract vocabularies and phrases
        final parsedData = _parseAIResponse(aiResponse);
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
