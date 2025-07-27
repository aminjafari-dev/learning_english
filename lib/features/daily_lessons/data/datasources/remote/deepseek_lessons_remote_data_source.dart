// deepseek_lessons_remote_data_source.dart
// Implementation of AiLessonsRemoteDataSource for DeepSeek AI
// All methods are personalized based on user preferences.
// Usage:
// final dataSource = DeepSeekLessonsRemoteDataSource(apiKey: 'YOUR_DEEPSEEK_API_KEY');
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

class DeepSeekLessonsRemoteDataSource implements AiLessonsRemoteDataSource {
  final Dio dio;
  final String apiKey;
  static const String _deepSeekEndpoint =
      'https://api.deepseek.com/v1/chat/completions';

  DeepSeekLessonsRemoteDataSource({Dio? dio, required this.apiKey})
    : dio = dio ?? Dio();

  @override
  Future<Either<Failure, List<Vocabulary>>> fetchPersonalizedDailyVocabularies(
    UserPreferences preferences,
  ) async {
    try {
      final response = await dio.post(
        _deepSeekEndpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content': AiPrompts.getPersonalizedVocabularySystemPrompt(
                preferences,
              ),
            },
            {
              'role': 'user',
              'content': AiPrompts.getPersonalizedVocabularyUserPrompt(
                preferences,
              ),
            },
          ],
          'max_tokens': 256,
        },
      );
      final content = response.data['choices'][0]['message']['content'];
      final List<dynamic> vocabList = jsonDecode(content);
      final vocabularies =
          vocabList
              .map(
                (e) => Vocabulary(english: e['english'], persian: e['persian']),
              )
              .toList();
      return right(vocabularies);
    } catch (e) {
      return left(
        ServerFailure(
          'Failed to fetch personalized vocabularies: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Phrase>>> fetchPersonalizedDailyPhrases(
    UserPreferences preferences,
  ) async {
    try {
      final response = await dio.post(
        _deepSeekEndpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': 'deepseek-chat',
          'messages': [
            {
              'role': 'system',
              'content': AiPrompts.getPersonalizedPhraseSystemPrompt(
                preferences,
              ),
            },
            {
              'role': 'user',
              'content': AiPrompts.getPersonalizedPhraseUserPrompt(preferences),
            },
          ],
          'max_tokens': 256,
        },
      );
      final content = response.data['choices'][0]['message']['content'];
      final List<dynamic> phraseList = jsonDecode(content);
      final phrases =
          phraseList
              .map((e) => Phrase(english: e['english'], persian: e['persian']))
              .toList();
      return right(phrases);
    } catch (e) {
      return left(
        ServerFailure('Failed to fetch personalized phrases: ${e.toString()}'),
      );
    }
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
        _deepSeekEndpoint,
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'model': 'deepseek-chat',
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
