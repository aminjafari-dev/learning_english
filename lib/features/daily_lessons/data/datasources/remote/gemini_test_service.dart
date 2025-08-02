// gemini_test_service.dart
// Simple test service to verify Gemini API connection
// This helps debug API issues

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple test service for Gemini API
class GeminiTestService {
  final String apiKey;
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';

  GeminiTestService(this.apiKey);

  /// Test basic Gemini API connection
  Future<bool> testConnection() async {
    try {
      print('🧪 [TEST] Testing Gemini API connection...');
      print('🧪 [TEST] API Key: ${apiKey.substring(0, 10)}...');
      print('🧪 [TEST] Base URL: $baseUrl');

      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': 'Hello, can you respond with "API test successful"?'},
              ],
            },
          ],
          'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 100},
        }),
      );

      print('🧪 [TEST] Response status: ${response.statusCode}');
      print('🧪 [TEST] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        print('🧪 [TEST] Success! Response: $text');
        return true;
      } else {
        print('❌ [TEST] API error: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ [TEST] Connection error: $e');
      return false;
    }
  }

  /// Test with the actual lesson prompt
  Future<bool> testLessonPrompt() async {
    try {
      print('🧪 [TEST] Testing lesson prompt...');

      final prompt =
          '''You are an English teacher helping me learn new vocabulary and phrases. 
I'm at intermediate level and I want to focus on business.

IMPORTANT REQUIREMENTS:
1. Suggest ONLY NEW words and phrases that I haven't learned before
2. Make suggestions practical and useful for my level
3. Include Persian translations
4. Format response as JSON with "vocabularies" and "phrases" arrays

Please suggest 5 new vocabulary words and 3 new phrases that are:
- Different from what I've already learned
- Appropriate for my intermediate level
- Focused on business
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

      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 1000},
        }),
      );

      print('🧪 [TEST] Lesson prompt response status: ${response.statusCode}');
      print('🧪 [TEST] Lesson prompt response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        print(
          '🧪 [TEST] Lesson prompt success! Response: ${text.substring(0, 200)}...',
        );
        return true;
      } else {
        print(
          '❌ [TEST] Lesson prompt API error: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('❌ [TEST] Lesson prompt error: $e');
      return false;
    }
  }
}

// Example usage:
// final testService = GeminiTestService('YOUR_API_KEY');
// final isConnected = await testService.testConnection();
// final isLessonWorking = await testService.testLessonPrompt();
