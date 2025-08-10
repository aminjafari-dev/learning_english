// gemini_conversation_service.dart
// Learning Conversation service for generating educational content with data storage.
// Uses the deployed learning-conversation Edge Function for AI responses and automatic data persistence.

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:learning_english/features/daily_lessons/data/models/level_type.dart';
import '../local/daily_lessons_local_data_source.dart';

/// Learning Conversation service for generating educational content with automatic data storage
/// Uses deployed learning-conversation Edge Function for AI responses and data persistence
class GeminiConversationService {
  final DailyLessonsLocalDataSource _localDataSource;
  final SupabaseClient _supabaseClient;

  GeminiConversationService(this._localDataSource, String apiKey)
    : _supabaseClient = Supabase.instance.client;

  /// Initialize the conversation service
  Future<void> initialize() async {
    await _localDataSource.initialize();
  }

  /// Send a message to Learning Conversation Edge Function for educational content generation
  /// Uses dynamic prompts from database and automatically stores conversation data
  Future<String> sendMessage(
    String message, {
    UserLevel? userLevel,
    List<String>? focusAreas,
  }) async {
    try {
      // Convert UserLevel enum to string
      final levelString = userLevel?.name ?? 'intermediate';

      // Get current user ID for data storage
      final userId =
          Supabase.instance.client.auth.currentUser?.id ?? 'anonymous_user';

      // Prepare request body for Edge Function (prompt is now fetched dynamically from database)
      final requestBody = {
        'message': message,
        'userId': userId,
        'userLevel': levelString,
        'focusAreas': focusAreas ?? ['general'],
      };

      // Call Supabase Edge Function (updated to new learning-conversation function)
      final response = await _supabaseClient.functions.invoke(
        'learning-conversation',
        body: requestBody,
      );

      // Handle the response
      if (response.data != null && response.data['success'] == true) {
        final aiResponse = response.data['response'] as String?;
        if (aiResponse != null && aiResponse.isNotEmpty) {
          return aiResponse;
        }
      }

      // Handle error case
      if (response.data != null && response.data['error'] != null) {
        throw Exception('Edge Function error: ${response.data['error']}');
      }

      return 'No response generated';
    } catch (e) {
      print('Error calling Supabase Edge Function: $e');
      rethrow;
    }
  }
}

// Example usage:
// final geminiService = GeminiConversationService(localDataSource, ''); // API key not needed
// await geminiService.initialize();
// final response = await geminiService.sendMessage(
//   'Help me practice English conversation',
//   userLevel: UserLevel.intermediate,
//   focusAreas: ['conversation', 'vocabulary'],
// );
// Note: Prompts are now dynamically fetched from database based on message analysis
