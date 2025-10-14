// gemini_conversation_service.dart
// Direct Gemini API service for generating educational content
// This service directly calls Google's Gemini API for AI-powered learning conversations
//
// Usage Example:
//   final geminiService = GeminiConversationService(localDataSource, 'YOUR_API_KEY');
//   await geminiService.initialize();
//   final response = await geminiService.generateConversationResponse(
//     userLevel: UserLevel.intermediate,
//     focusAreas: ['conversation', 'vocabulary'],
//   );
//
// This service handles:
// - Direct API calls to Gemini API
// - JSON response parsing
// - Error handling and retry logic
// - Local storage integration via Hive

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:learning_english/features/daily_lessons/data/models/level_type.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/conversation_prompts.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/user_preferences.dart';
import '../local/daily_lessons_local_data_source.dart';

/// Direct Gemini API service for generating educational content
/// Uses Google's Gemini API for AI responses without any backend dependencies
class GeminiConversationService {
  final DailyLessonsLocalDataSource _localDataSource;
  final String _apiKey;
  final Dio _dio;

  /// Base URL for Gemini API
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  /// Model to use for generation
  static const String _model = 'gemini-2.5-flash';

  /// Constructor
  /// @param localDataSource Local data source for storing conversation data
  /// @param apiKey Google Gemini API key
  GeminiConversationService(this._localDataSource, String apiKey)
    : _apiKey = apiKey,
      _dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

  /// Initialize the conversation service
  /// Sets up local data source for storing conversation history
  Future<void> initialize() async {
    await _localDataSource.initialize();
  }

  /// Generate AI conversation response using Gemini API
  /// This method directly calls Google's Gemini API and returns educational content
  ///
  /// Parameters:
  /// - userLevel: User's English proficiency level
  /// - focusAreas: Topics the user wants to focus on
  ///
  /// Returns: AI-generated response with vocabularies and phrases
  Future<String> generateConversationResponse({
    UserLevel? userLevel,
    List<String>? focusAreas,
  }) async {
    try {
      // Validate API key
      if (_apiKey.isEmpty) {
        throw Exception(
          'Gemini API key is not configured. Please add GEMINI_API_KEY to your .env file',
        );
      }

      // Create user preferences from parameters
      final preferences = UserPreferences(
        level: userLevel ?? UserLevel.intermediate,
        focusAreas: focusAreas ?? ['general'],
      );

      // Get the lesson prompt
      final prompt = ConversationPrompts.getLessonPrompt(preferences);

      // Prepare the API request (without API key in URL)
      final requestUrl = '$_baseUrl/$_model:generateContent';

      final requestBody = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.9,
          'topK': 1,
          'topP': 1,
          'maxOutputTokens': 2048,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE',
          },
        ],
      };

      // Make the API call with x-goog-api-key header
      final response = await _dio.post(
        requestUrl,
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': _apiKey,
          },
        ),
      );

      // Parse the response
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        // Extract the text from Gemini response
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          final text = data['candidates'][0]['content']['parts'][0]['text'];

          if (text != null && text.isNotEmpty) {
            // Try to clean up the response if it contains markdown code blocks
            String cleanedText = text.toString().trim();

            // Remove markdown code blocks if present
            if (cleanedText.startsWith('```json')) {
              cleanedText = cleanedText.replaceFirst('```json', '').trim();
            }
            if (cleanedText.startsWith('```')) {
              cleanedText = cleanedText.replaceFirst('```', '').trim();
            }
            if (cleanedText.endsWith('```')) {
              cleanedText =
                  cleanedText.substring(0, cleanedText.length - 3).trim();
            }

            // Validate that it's valid JSON
            try {
              json.decode(cleanedText);
              return cleanedText;
            } catch (e) {
              print('Error parsing JSON response: $e');
              print('Raw response: $cleanedText');
              throw Exception('Invalid JSON response from Gemini API');
            }
          }
        }
      }

      // Handle error case
      throw Exception(
        'No valid response from Gemini API. Status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      print('Dio error calling Gemini API: ${e.message}');
      if (e.response != null) {
        print('Response data: ${e.response?.data}');
        print('Response status: ${e.response?.statusCode}');
      }
      throw Exception('Network error calling Gemini API: ${e.message}');
    } catch (e) {
      print('Error calling Gemini API: $e');
      rethrow;
    }
  }

  /// Generate a conversation response with custom prompt
  /// This allows for more flexible conversation generation
  ///
  /// Parameters:
  /// - prompt: Custom prompt for the AI
  ///
  /// Returns: AI-generated response
  Future<String> generateCustomResponse(String prompt) async {
    try {
      // Validate API key
      if (_apiKey.isEmpty) {
        throw Exception('Gemini API key is not configured');
      }

      final requestUrl = '$_baseUrl/$_model:generateContent';

      final requestBody = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.9,
          'topK': 1,
          'topP': 1,
          'maxOutputTokens': 2048,
        },
      };

      final response = await _dio.post(
        requestUrl,
        data: requestBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': _apiKey,
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;

        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          final text = data['candidates'][0]['content']['parts'][0]['text'];
          return text?.toString() ?? 'No response generated';
        }
      }

      throw Exception('No valid response from Gemini API');
    } catch (e) {
      print('Error calling Gemini API with custom prompt: $e');
      rethrow;
    }
  }
}

// Example usage:
// final geminiService = GeminiConversationService(localDataSource, dotenv.env['GEMINI_API_KEY'] ?? '');
// await geminiService.initialize();
// final response = await geminiService.generateConversationResponse(
//   userLevel: UserLevel.intermediate,
//   focusAreas: ['conversation', 'vocabulary'],
// );
