// gemini_conversation_service.dart
// Supabase Edge Function conversation service for generating educational content.
// Uses the deployed Edge Function instead of calling Gemini directly for better security and performance.

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:learning_english/features/daily_lessons/data/models/level_type.dart';
import '../local/daily_lessons_local_data_source.dart';

/// Supabase Edge Function conversation service for generating educational content
/// Uses deployed Edge Function instead of direct Gemini API calls
class GeminiConversationService {
  final DailyLessonsLocalDataSource _localDataSource;
  final SupabaseClient _supabaseClient;

  GeminiConversationService(this._localDataSource, String apiKey)
    : _supabaseClient = Supabase.instance.client;

  /// Initialize the conversation service
  Future<void> initialize() async {
    await _localDataSource.initialize();
  }

  /// Send a message to Supabase Edge Function for educational content generation
  /// Each call is independent - no conversation history is maintained
  Future<String> sendMessage(
    String userId,
    String message, {
    UserLevel? userLevel,
    List<String>? focusAreas,
  }) async {
    try {
      // Convert UserLevel enum to string
      final levelString = userLevel?.name ?? 'intermediate';

      // Prepare request body for Edge Function
      final requestBody = {
        'message': message,
        'userLevel': levelString,
        'focusAreas': focusAreas ?? ['general'],
      };

      // Call Supabase Edge Function
      final response = await _supabaseClient.functions.invoke(
        'gemini-conversation',
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
// final geminiService = GeminiConversationService(localDataSource, ''); // API key not needed anymore
// await geminiService.initialize();
// final response = await geminiService.sendMessage(
//   'user123',
//   'Help me practice English conversation',
//   userLevel: UserLevel.intermediate,
//   focusAreas: ['conversation', 'vocabulary'],
// );
