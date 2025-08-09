// gemini_conversation_service.dart
// Gemini conversation service for generating educational content.
// Simplified to work without thread persistence - each conversation is independent.

import 'package:dio/dio.dart';
import 'package:learning_english/features/daily_lessons/data/models/level_type.dart';
import '../local/daily_lessons_local_data_source.dart';
import '../../models/learning_request_model.dart';
import '../../models/vocabulary_model.dart';
import '../../models/phrase_model.dart';

/// Gemini conversation service for generating educational content
/// Simplified to work without thread persistence
class GeminiConversationService {
  final DailyLessonsLocalDataSource _localDataSource;
  final String _apiKey;
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';

  // Dio instance for HTTP requests
  late final Dio _dio;

  GeminiConversationService(this._localDataSource, this._apiKey) {
    // Initialize Dio with default configuration
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  /// Initialize the conversation service
  Future<void> initialize() async {
    await _localDataSource.initialize();
  }

  /// Send a message to Gemini for educational content generation
  /// Each call is independent - no conversation history is maintained
  Future<String> sendMessage(
    String userId,
    String message, {
    UserLevel? userLevel,
    List<String>? focusAreas,
  }) async {
    try {
      // Get user's learning history from Hive for context
      final userRequests = await _localDataSource.getUserRequests(userId);
      final usedVocabularies = await _localDataSource.getUserVocabularies(
        userId,
      );
      final usedPhrases = await _localDataSource.getUserPhrases(userId);

      // Create context-aware prompt
      final contextPrompt = _createContextPrompt(
        message,
        usedVocabularies,
        usedPhrases,
        userRequests,
        userLevel ?? UserLevel.intermediate,
        focusAreas ?? ['general'],
      );

      // Send to Gemini API
      final response = await _dio.post(
        '$_baseUrl?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': contextPrompt},
              ],
            },
          ],
          'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 1024},
        },
      );

      final responseData = response.data;
      if (responseData != null &&
          responseData['candidates'] != null &&
          responseData['candidates'].isNotEmpty) {
        final content = responseData['candidates'][0]['content'];
        if (content != null &&
            content['parts'] != null &&
            content['parts'].isNotEmpty) {
          return content['parts'][0]['text'] ?? 'No response generated';
        }
      }

      return 'No response generated';
    } catch (e) {
      print('Error sending message to Gemini: $e');
      rethrow;
    }
  }

  /// Create context-aware prompt for Gemini
  String _createContextPrompt(
    String message,
    List<VocabularyModel> usedVocabularies,
    List<PhraseModel> usedPhrases,
    List<LearningRequestModel> userRequests,
    UserLevel userLevel,
    List<String> focusAreas,
  ) {
    final usedVocabWords = usedVocabularies.map((v) => v.english).toList();
    final usedPhraseTexts = usedPhrases.map((p) => p.english).toList();

    return '''
You are an English learning assistant. The user is at ${userLevel.name} level and focusing on: ${focusAreas.join(', ')}.

User's learning history:
- Previously learned vocabulary: ${usedVocabWords.take(10).join(', ')}
- Previously learned phrases: ${usedPhraseTexts.take(5).join(', ')}

Current user message: "$message"

Please provide a helpful educational response in English. Keep it appropriate for ${userLevel.name} level.
If you provide new vocabulary or phrases, please format them as:
Vocabulary: [word] - [meaning]
Phrases: [phrase] - [meaning]

Response:''';
  }
}

// Example usage:
// final geminiService = GeminiConversationService(localDataSource, apiKey);
// await geminiService.initialize();
// final response = await geminiService.sendMessage(
//   'user123',
//   'Help me practice English conversation',
//   userLevel: UserLevel.intermediate,
//   focusAreas: ['conversation', 'vocabulary'],
// );
