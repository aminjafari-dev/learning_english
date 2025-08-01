// gemini_lessons_remote_data_source.dart
// Implementation of AiLessonsRemoteDataSource for Gemini AI
// All methods are personalized based on user preferences.
// Usage:
// final dataSource = GeminiLessonsRemoteDataSource(apiKey: 'YOUR_GEMINI_API_KEY');
// final preferences = UserPreferences(level: Level.intermediate, focusAreas: ['business', 'travel']);
// final personalizedResult = await dataSource.fetchPersonalizedDailyLessons(preferences);

import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../domain/entities/vocabulary.dart';
import '../../../domain/entities/phrase.dart';
import '../../../domain/entities/ai_usage_metadata.dart';
import '../../../domain/entities/user_preferences.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:learning_english/core/error/failure.dart';
import 'ai_lessons_remote_data_source.dart';
import 'ai_prompts.dart';

class GeminiLessonsRemoteDataSource implements AiLessonsRemoteDataSource {
  final Dio dio;
  final String apiKey;
  static const String _geminiEndpoint =
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent';

  GeminiLessonsRemoteDataSource({Dio? dio, required this.apiKey})
    : dio = dio ?? Dio();

  /// Extracts JSON content from markdown code blocks
  /// Removes ```json and ``` markers if present
  String _extractJsonFromMarkdown(String text) {
    // Remove markdown code block markers if present
    if (text.trim().startsWith('```json')) {
      text = text.trim().substring(7); // Remove ```json
    }
    if (text.trim().startsWith('```')) {
      text = text.trim().substring(3); // Remove ```
    }
    if (text.trim().endsWith('```')) {
      text = text.trim().substring(
        0,
        text.trim().length - 3,
      ); // Remove trailing ```
    }
    return text.trim();
  }

  @override
  Future<
    Either<
      Failure,
      ({
        List<Vocabulary> vocabularies,
        List<Phrase> phrases,
        AiUsageMetadata metadata,
      })
    >
  >
  fetchPersonalizedDailyLessons(UserPreferences preferences) async {
    try {
      final response = await dio.post(
        '$_geminiEndpoint?key=$apiKey',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'contents': [
            {
              'role': 'user',
              'parts': [
                {
                  'text': AiPrompts.getPersonalizedLessonsSystemPrompt(
                    preferences,
                  ),
                },
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1000,
          },
        },
      );

      // Extract the full response data for metadata
      final responseData = response.data as Map<String, dynamic>;
      final text = responseData['candidates'][0]['content']['parts'][0]['text'];
      log('Personalized lessons response: ${responseData.toString()}');

      // Extract JSON from markdown code blocks if present
      final cleanText = _extractJsonFromMarkdown(text);
      final Map<String, dynamic> lessonsData = jsonDecode(cleanText);

      final List<dynamic> vocabList = lessonsData['vocabularies'] ?? [];
      final List<dynamic> phraseList = lessonsData['phrases'] ?? [];

      final vocabularies =
          vocabList
              .map(
                (e) => Vocabulary(english: e['english'], persian: e['persian']),
              )
              .toList();

      final phrases =
          phraseList
              .map((e) => Phrase(english: e['english'], persian: e['persian']))
              .toList();

      // Extract usage metadata from the response
      final metadata = AiUsageMetadata.fromJson(responseData);

      return right((
        vocabularies: vocabularies,
        phrases: phrases,
        metadata: metadata,
      ));
    } catch (e) {
      log('Personalized lessons error: ${e.toString()}');
      return left(
        ServerFailure(
          'Failed to fetch personalized daily lessons: ${e.toString()}',
        ),
      );
    }
  }
}
