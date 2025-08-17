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

  /// Generate AI conversation response using dynamic prompts from database
  /// Uses database prompts and user preferences for educational content generation
  /// Automatically stores conversation data without requiring any message input
  Future<String> generateConversationResponse({
    UserLevel? userLevel,
    List<String>? focusAreas,
  }) async {
    try {
      // Convert UserLevel enum to string
      final levelString = userLevel?.name ?? 'intermediate';

      // Get current user ID for data storage
      final userId =
          Supabase.instance.client.auth.currentUser?.id ?? 'anonymous_user';

      // Prepare request body for Edge Function (prompts are fetched dynamically from database)
      // No message needed - Edge Function will determine appropriate prompts based on user preferences
      final requestBody = {
        'userId': userId,
        'userLevel': levelString,
        'focusAreas': focusAreas ?? ['general'],
      };

      // Call Supabase Edge Function with authentication
      final response = await _supabaseClient.functions.invoke(
        'learning-conversation',
        body: requestBody,
        // The Supabase client automatically includes the user's JWT token
        // This ensures the function can validate authentication
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
// final response = await geminiService.generateConversationResponse(
//   userLevel: UserLevel.intermediate,
//   focusAreas: ['conversation', 'vocabulary'],
// );
// Note: Prompts are dynamically fetched from database based on user preferences and focus areas
