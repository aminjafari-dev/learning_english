// openai_lessons_remote_data_source.dart
// Implementation of AiLessonsRemoteDataSource for OpenAI (ChatGPT)
// Usage:
// final dataSource = OpenAiLessonsRemoteDataSource(apiKey: 'YOUR_API_KEY');
// final vocabResult = await dataSource.fetchDailyVocabularies();
// final phraseResult = await dataSource.fetchDailyPhrases();
// final lessonsResult = await dataSource.fetchDailyLessons(); // More cost-effective

import 'package:dartz/dartz.dart';
import '../../../domain/entities/vocabulary.dart';
import '../../../domain/entities/phrase.dart';
import '../../../domain/entities/ai_usage_metadata.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:learning_english/core/error/failure.dart';
import 'ai_lessons_remote_data_source.dart';

class OpenAiLessonsRemoteDataSource implements AiLessonsRemoteDataSource {
  final Dio dio;
  final String apiKey;
  static const String _openAiEndpoint =
      'https://api.openai.com/v1/chat/completions';

  OpenAiLessonsRemoteDataSource({Dio? dio, required this.apiKey})
    : dio = dio ?? Dio();

  @override
  Future<Either<Failure, List<Vocabulary>>> fetchDailyVocabularies() async {
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
              'content':
                  'You are an English teacher. Provide a list of 4 useful English vocabulary words for daily learning, each with its Persian translation. Respond in JSON: [{"english": "...", "persian": "..."}, ...]',
            },
            {
              'role': 'user',
              'content':
                  'Give me 4 English vocabulary words with Persian translations.',
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
        ServerFailure('Failed to fetch vocabularies: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Phrase>>> fetchDailyPhrases() async {
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
              'content':
                  'You are an English teacher. Provide a list of 2 useful English phrases for daily learning, each with its Persian translation. Respond in JSON: [{"english": "...", "persian": "..."}, ...]',
            },
            {
              'role': 'user',
              'content': 'Give me 2 English phrases with Persian translations.',
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
      return left(ServerFailure('Failed to fetch phrases: ${e.toString()}'));
    }
  }

  @override
  Future<
    Either<Failure, ({
      List<Vocabulary> vocabularies, 
      List<Phrase> phrases,
      AiUsageMetadata metadata
    })>
  >
  fetchDailyLessons() async {
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
              'content':
                  'You are an English teacher. Provide both vocabulary words and phrases for daily learning. Respond in JSON format with two arrays: vocabularies and phrases. Each vocabulary should have English and Persian translations, and each phrase should have English and Persian translations.',
            },
            {
              'role': 'user',
              'content':
                  'Give me 4 English vocabulary words and 2 English phrases, all with Persian translations.',
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
        metadata: metadata
      ));
    } catch (e) {
      return left(
        ServerFailure('Failed to fetch daily lessons: ${e.toString()}'),
      );
    }
  }
}
