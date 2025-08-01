// openai_lessons_remote_data_source.dart
// Implementation of AiLessonsRemoteDataSource for OpenAI (ChatGPT)
// All methods are personalized based on user preferences.
// Usage:
// final dataSource = OpenAiLessonsRemoteDataSource(apiKey: 'YOUR_API_KEY');
// final preferences = UserPreferences(level: Level.intermediate, focusAreas: ['business', 'travel']);
// final personalizedResult = await dataSource.fetchPersonalizedDailyLessons(preferences);

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

class OpenAiLessonsRemoteDataSource implements AiLessonsRemoteDataSource {
  final Dio dio;
  final String apiKey;
  static const String _openAiEndpoint =
      'https://api.openai.com/v1/chat/completions';

  OpenAiLessonsRemoteDataSource({Dio? dio, required this.apiKey})
    : dio = dio ?? Dio();

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
        _openAiEndpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': AiPrompts.getPersonalizedLessonsSystemPrompt(
                preferences,
              ),
            },
            {
              'role': 'user',
              'content': AiPrompts.getPersonalizedLessonsUserPrompt(
                preferences,
              ),
            },
          ],
          'max_tokens': 512,
        },
      );

      // Extract the full response data for metadata
      final responseData = response.data as Map<String, dynamic>;
      final content = responseData['choices'][0]['message']['content'];
      final Map<String, dynamic> lessonsData = jsonDecode(content);

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
      return left(
        ServerFailure(
          'Failed to fetch personalized daily lessons: ${e.toString()}',
        ),
      );
    }
  }
}
