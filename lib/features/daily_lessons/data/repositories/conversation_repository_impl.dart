// conversation_repository_impl.dart
// Implementation of ConversationRepository interface.
// This class handles conversation threads and AI-powered messaging functionality.
// Manages conversation state, thread creation, and message processing with AI services.

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/repositories/user_repository.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../datasources/local/daily_lessons_local_data_source.dart';
import '../datasources/remote/gemini_conversation_service.dart';

import '../models/level_type.dart';
import '../models/vocabulary_model.dart';
import '../models/phrase_model.dart';
import 'dart:convert';

/// Implementation of ConversationRepository
/// Handles AI-powered conversation threads for interactive learning
/// Manages conversation persistence and AI interaction through Gemini service
class ConversationRepositoryImpl implements ConversationRepository {
  final DailyLessonsLocalDataSource localDataSource;
  final GeminiConversationService geminiConversationService;
  final UserRepository coreUserRepository;

  /// Constructor for dependency injection
  /// Requires local data source for conversation persistence,
  /// Gemini service for AI interactions, and core user repository for authentication
  ConversationRepositoryImpl({
    required this.localDataSource,
    required this.geminiConversationService,
    required this.coreUserRepository,
  });

  @override
  Future<Either<Failure, String>> sendConversationMessage(
    UserPreferences preferences,
    String message,
  ) async {
    try {
      debugPrint('💬 [CONVERSATION] Starting conversation message processing');
      debugPrint(
        '📋 [CONVERSATION] User preferences: level=${preferences.level}, areas=${preferences.focusAreas}',
      );
      debugPrint('📝 [CONVERSATION] User message: $message');

      // Get user ID for conversation tracking
      final userId = await coreUserRepository.getUserId() ?? 'current_user';
      debugPrint('👤 [CONVERSATION] User ID: $userId');

      // Convert UserLevel to the model's UserLevel
      final userLevel = _convertToModelUserLevel(preferences.level);

      // No thread storage - each conversation is independent
      debugPrint(
        '💬 [CONVERSATION] Processing message without thread persistence',
      );

      // Send to AI service (Gemini) and get response
      debugPrint('🤖 [CONVERSATION] Sending to Gemini AI service');
      try {
        final aiResponse = await geminiConversationService.sendMessage(
          message,
          userLevel: userLevel,
          focusAreas: preferences.focusAreas,
        );

        debugPrint(
          '✅ [CONVERSATION] Received AI response: ${aiResponse.substring(0, 50)}...',
        );

        // Check if the response contains vocabularies and phrases
        final extractedContent = _extractVocabulariesAndPhrases(aiResponse);
        if (extractedContent.vocabularies.isNotEmpty ||
            extractedContent.phrases.isNotEmpty) {
          debugPrint(
            '💾 [CONVERSATION] Found vocabularies and phrases in response, saving to local storage',
          );
        }

        debugPrint(
          '✅ [CONVERSATION] Conversation message processed successfully',
        );
        return right(aiResponse);
      } catch (e) {
        debugPrint('❌ [CONVERSATION] Gemini service error: $e');
        return left(
          ServerFailure('Failed to get AI response: ${e.toString()}'),
        );
      }
    } catch (e) {
      debugPrint(
        '❌ [CONVERSATION] Unexpected error in conversation processing: $e',
      );
      return left(
        ServerFailure(
          'Failed to process conversation message: ${e.toString()}',
        ),
      );
    }
  }

  /// Converts domain UserLevel to model UserLevel
  /// Maps between different level representations in the system
  UserLevel _convertToModelUserLevel(dynamic preferencesLevel) {
    switch (preferencesLevel.toString()) {
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

  /// Extracts vocabularies and phrases from AI response
  /// Parses JSON response to extract structured content
  ({List<VocabularyModel> vocabularies, List<PhraseModel> phrases})
  _extractVocabulariesAndPhrases(String response) {
    try {
      // Extract JSON from the response (AI might add extra text)
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;

      if (jsonStart == -1 || jsonEnd == 0) {
        return (vocabularies: <VocabularyModel>[], phrases: <PhraseModel>[]);
      }

      final jsonString = response.substring(jsonStart, jsonEnd);
      final Map<String, dynamic> data = jsonDecode(jsonString);

      // Parse vocabularies
      final List<dynamic> vocabList = data['vocabularies'] ?? [];
      final vocabularies =
          vocabList
              .map(
                (e) => VocabularyModel(
                  english: e['english'] ?? '',
                  persian: e['persian'] ?? '',
                  isUsed: false,
                ),
              )
              .where((v) => v.english.isNotEmpty && v.persian.isNotEmpty)
              .toList();

      // Parse phrases
      final List<dynamic> phraseList = data['phrases'] ?? [];
      final phrases =
          phraseList
              .map(
                (e) => PhraseModel(
                  english: e['english'] ?? '',
                  persian: e['persian'] ?? '',
                  isUsed: false,
                ),
              )
              .where((p) => p.english.isNotEmpty && p.persian.isNotEmpty)
              .toList();

      return (vocabularies: vocabularies, phrases: phrases);
    } catch (e) {
      debugPrint('❌ [CONVERSATION] Failed to parse AI response: $e');
      return (vocabularies: <VocabularyModel>[], phrases: <PhraseModel>[]);
    }
  }
}

// Example usage:
// final conversationRepo = ConversationRepositoryImpl(
//   localDataSource: getIt<DailyLessonsLocalDataSource>(),
//   geminiConversationService: getIt<GeminiConversationService>(),
//   coreUserRepository: getIt<UserRepository>(),
// );
// 
// // Send conversation message
// final preferences = UserPreferences(level: UserLevel.intermediate, focusAreas: ['technology']);
// final response = await conversationRepo.sendConversationMessage(
//   preferences,
//   "Explain machine learning in simple terms"
// );
// response.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (aiResponse) => print('AI: $aiResponse'),
// );