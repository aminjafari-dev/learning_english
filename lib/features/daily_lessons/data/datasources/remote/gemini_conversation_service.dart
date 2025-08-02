// gemini_conversation_service.dart
// Gemini conversation service for maintaining message threads and conversation context.
// Integrates with existing Hive database to avoid repetitive content and provide personalized learning.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:learning_english/features/daily_lessons/data/models/level_type.dart';
import '../local/daily_lessons_local_data_source.dart';
import '../../models/learning_request_model.dart';
import '../../models/vocabulary_model.dart';
import '../../models/phrase_model.dart';
import '../../models/conversation_thread_model.dart';
import '../../../domain/entities/user_preferences.dart';

/// Gemini conversation service for maintaining message threads
/// Integrates with Hive database to provide context-aware responses
class GeminiConversationService {
  final DailyLessonsLocalDataSource _localDataSource;
  final String _apiKey;
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  // Current active thread for each user (loaded from Hive)
  final Map<String, ConversationThreadModel?> _activeThreads = {};

  GeminiConversationService(this._localDataSource, this._apiKey);

  /// Initialize the conversation service
  Future<void> initialize() async {
    await _localDataSource.initialize();
  }

  /// Send a message to Gemini with conversation context
  /// Uses preference-based thread management
  Future<String> sendMessage(
    String userId,
    String message, {
    UserLevel? userLevel,
    List<String>? focusAreas,
  }) async {
    try {
      // Get user's learning history from Hive
      final userRequests = await _localDataSource.getUserRequests(userId);
      final usedVocabularies = await _localDataSource.getUserVocabularies(
        userId,
      );
      final usedPhrases = await _localDataSource.getUserPhrases(userId);

      // Get or create conversation thread based on preferences
      ConversationThreadModel? activeThread = _activeThreads[userId];

      if (userLevel != null && focusAreas != null) {
        // Try to find existing thread for these preferences
        activeThread = await _localDataSource.findThreadByPreferences(
          userId,
          userLevel,
          focusAreas,
        );

        if (activeThread == null) {
          // Create new thread for these preferences
          activeThread = ConversationThreadModel.create(
            userId: userId,
            context: 'daily_lessons',
            userLevel: userLevel,
            focusAreas: focusAreas,
          );
          // Save the new thread
          await _localDataSource.saveConversationThread(activeThread);
        }

        _activeThreads[userId] = activeThread;
      } else {
        // Fallback to existing logic for backward compatibility
        if (activeThread == null) {
          final userThreads = await _localDataSource.getUserConversationThreads(
            userId,
          );
          if (userThreads.isNotEmpty) {
            activeThread = userThreads.reduce(
              (a, b) => a.lastUpdatedAt.isAfter(b.lastUpdatedAt) ? a : b,
            );
          } else {
            // Create default thread
            activeThread = ConversationThreadModel.create(
              userId: userId,
              context: 'daily_lessons',
              userLevel: UserLevel.intermediate,
              focusAreas: ['general'],
            );
          }
          _activeThreads[userId] = activeThread;
        }
      }

      // Create context-aware prompt
      final contextPrompt = _createContextPrompt(
        message,
        usedVocabularies,
        usedPhrases,
        userRequests,
        activeThread,
      );

      // Add user message to thread
      final userMessage = ConversationMessageModel.user(contextPrompt);
      activeThread = activeThread.addMessage(userMessage);

      // Convert thread to Gemini format
      final geminiThread = _convertToGeminiFormat(activeThread);

      // Send request to Gemini
      final response = await _sendToGemini(geminiThread);

      // Add Gemini response to thread
      final modelMessage = ConversationMessageModel.model(response);
      activeThread = activeThread.addMessage(modelMessage);

      // Save updated thread to Hive
      await _localDataSource.updateConversationThread(activeThread);
      _activeThreads[userId] = activeThread;

      return response;
    } catch (e) {
      throw Exception('Failed to send message to Gemini: ${e.toString()}');
    }
  }

  /// Create context-aware prompt using stored learning history
  String _createContextPrompt(
    String userMessage,
    List<VocabularyModel> usedVocabularies,
    List<PhraseModel> usedPhrases,
    List<LearningRequestModel> userRequests,
    ConversationThreadModel activeThread,
  ) {
    final usedWords = usedVocabularies.map((v) => v.english).toList();
    final usedPhraseTexts = usedPhrases.map((p) => p.english).toList();

    // Get conversation context from thread
    final conversationContext = activeThread.conversationSummary;

    return '''
$userMessage

CONTEXT FROM PREVIOUS LEARNING SESSIONS:
- Previously used vocabulary words: ${usedWords.take(20).join(', ')}
- Previously used phrases: ${usedPhraseTexts.take(10).join(', ')}
- Conversation context: $conversationContext

IMPORTANT INSTRUCTIONS:
1. Avoid suggesting any of the previously used words or phrases listed above
2. Provide fresh, new content that hasn't been covered before
3. Ensure variety in vocabulary selection (mix of nouns, verbs, adjectives)
4. Include practical, commonly used expressions
5. Provide Persian translations without English transliterations (Finglish)
6. Build upon the conversation context to provide coherent learning progression

Please respond with new, diverse content that builds upon previous learning without repetition.
''';
  }

  /// Convert ConversationThreadModel to Gemini API format
  List<Map<String, dynamic>> _convertToGeminiFormat(
    ConversationThreadModel thread,
  ) {
    return thread.messages
        .map(
          (message) => {
            'role': message.role,
            'parts': [
              {'text': message.content},
            ],
          },
        )
        .toList();
  }

  /// Send request to Gemini API
  Future<String> _sendToGemini(List<Map<String, dynamic>> thread) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': thread,
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1000,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception(
          'Gemini API error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Failed to communicate with Gemini: ${e.toString()}');
    }
  }

  /// Get personalized vocabulary based on conversation context
  /// Uses preference-based thread management
  Future<List<VocabularyModel>> getPersonalizedVocabularies(
    String userId,
    UserPreferences preferences,
  ) async {
    final prompt = '''
Generate exactly 5 new English vocabulary words for ${preferences.levelDescription} level 
focused on ${preferences.focusAreasString}.

Requirements:
- Choose words that are practical and commonly used
- Ensure variety (mix of nouns, verbs, adjectives, adverbs)
- Avoid any words from previous learning sessions
- Provide Persian translations without English transliterations

Respond in JSON format: [{"english": "...", "persian": "..."}]
''';

    final response = await sendMessage(
      userId,
      prompt,
      userLevel: preferences.level,
      focusAreas: preferences.focusAreas,
    );
    return _parseVocabulariesFromResponse(response);
  }

  /// Get personalized phrases based on conversation context
  /// Uses preference-based thread management
  Future<List<PhraseModel>> getPersonalizedPhrases(
    String userId,
    UserPreferences preferences,
  ) async {
    final prompt = '''
Generate exactly 3 new English phrases for ${preferences.levelDescription} level 
focused on ${preferences.focusAreasString}.

Requirements:
- Choose practical, commonly used phrases
- Vary complexity and length
- Avoid any phrases from previous learning sessions
- Provide Persian translations without English transliterations

Respond in JSON format: [{"english": "...", "persian": "..."}]
''';

    final response = await sendMessage(
      userId,
      prompt,
      userLevel: preferences.level,
      focusAreas: preferences.focusAreas,
    );
    return _parsePhrasesFromResponse(response);
  }

  /// Parse vocabulary from Gemini response
  List<VocabularyModel> _parseVocabulariesFromResponse(String response) {
    try {
      final jsonMatch = RegExp(r'\[.*\]').firstMatch(response);
      if (jsonMatch == null) {
        throw Exception('No JSON array found in response');
      }

      final jsonString = jsonMatch.group(0)!;
      final List<dynamic> jsonList = jsonDecode(jsonString);

      return jsonList.map((item) {
        return VocabularyModel(
          english: item['english'] as String,
          persian: item['persian'] as String,
          isUsed: false,
        );
      }).toList();
    } catch (e) {
      throw Exception(
        'Failed to parse vocabularies from response: ${e.toString()}',
      );
    }
  }

  /// Parse phrases from Gemini response
  List<PhraseModel> _parsePhrasesFromResponse(String response) {
    try {
      final jsonMatch = RegExp(r'\[.*\]').firstMatch(response);
      if (jsonMatch == null) {
        throw Exception('No JSON array found in response');
      }

      final jsonString = jsonMatch.group(0)!;
      final List<dynamic> jsonList = jsonDecode(jsonString);

      return jsonList.map((item) {
        return PhraseModel(
          english: item['english'] as String,
          persian: item['persian'] as String,
          isUsed: false,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to parse phrases from response: ${e.toString()}');
    }
  }

  /// Get conversation thread for a user
  Future<ConversationThreadModel?> getConversationThread(String userId) async {
    return _activeThreads[userId];
  }

  /// Get all conversation threads for a user with preference information
  Future<List<Map<String, dynamic>>> getUserThreadsWithPreferences(
    String userId,
  ) async {
    return await _localDataSource.getUserThreadsWithPreferences(userId);
  }

  /// Find thread by specific preferences
  Future<ConversationThreadModel?> findThreadByPreferences(
    String userId,
    UserLevel level,
    List<String> focusAreas,
  ) async {
    return await _localDataSource.findThreadByPreferences(
      userId,
      level,
      focusAreas,
    );
  }

  /// Create thread with Gemini thread ID
  /// This allows using Gemini's thread ID for consistency
  Future<ConversationThreadModel> createThreadWithGeminiId(
    String userId,
    UserLevel level,
    List<String> focusAreas,
    String geminiThreadId,
  ) async {
    final thread = ConversationThreadModel.create(
      userId: userId,
      context: 'daily_lessons',
      userLevel: level,
      focusAreas: focusAreas,
      geminiThreadId: geminiThreadId,
    );

    await _localDataSource.saveConversationThread(thread);
    return thread;
  }

  /// Clear conversation thread for a user
  Future<void> clearConversationThread(String userId) async {
    _activeThreads.remove(userId);
    await _localDataSource.clearUserConversationThreads(userId);
  }

  /// Get conversation analytics
  Future<Map<String, dynamic>> getConversationAnalytics(String userId) async {
    return await _localDataSource.getConversationAnalytics(userId);
  }

  /// Dispose resources
  Future<void> dispose() async {
    await _localDataSource.dispose();
  }
}
