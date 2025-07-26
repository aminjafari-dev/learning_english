// gemini_lessons_remote_data_source.dart
// Implementation of AiLessonsRemoteDataSource for Gemini AI
// Usage:
// final dataSource = GeminiLessonsRemoteDataSource(apiKey: 'YOUR_GEMINI_API_KEY');
// final vocabResult = await dataSource.fetchDailyVocabularies();
// final phraseResult = await dataSource.fetchDailyPhrases();
// final lessonsResult = await dataSource.fetchDailyLessons(); // More cost-effective

import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../domain/entities/vocabulary.dart';
import '../../../domain/entities/phrase.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:learning_english/core/error/failure.dart';
import 'ai_lessons_remote_data_source.dart';

class GeminiLessonsRemoteDataSource implements AiLessonsRemoteDataSource {
  final Dio dio;
  final String apiKey;
  static const String _geminiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

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
  Future<Either<Failure, List<Vocabulary>>> fetchDailyVocabularies() async {
    try {
      final response = await dio.post(
        _geminiEndpoint,
        options: Options(
          headers: {
            'x-goog-api-key': apiKey,
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'You are an English teacher. Provide a list of 4 useful English vocabulary words for daily learning, each with its Persian translation. Respond in JSON: [{"english": "...", "persian": "..."}, ...]',
                },
              ],
            },
          ],
        },
      );
      final text =
          response.data['candidates'][0]['content']['parts'][0]['text'];
      log(response.data.toString());

      // Extract JSON from markdown code blocks if present
      final cleanText = _extractJsonFromMarkdown(text);
      final List<dynamic> vocabList = jsonDecode(cleanText);
      final vocabularies =
          vocabList
              .map(
                (e) => Vocabulary(english: e['english'], persian: e['persian']),
              )
              .toList();
      return right(vocabularies);
    } catch (e) {
      log(e.toString());
      return left(
        ServerFailure('Failed to fetch vocabularies: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Phrase>>> fetchDailyPhrases() async {
    try {
      final response = await dio.post(
        _geminiEndpoint,
        options: Options(
          headers: {
            'x-goog-api-key': apiKey,
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'You are an English teacher. Provide a list of 2 useful English phrases for daily learning, each with its Persian translation. Respond in JSON: [{"english": "...", "persian": "..."}, ...]',
                },
              ],
            },
          ],
        },
      );
      final text =
          response.data['candidates'][0]['content']['parts'][0]['text'];
      // Extract JSON from markdown code blocks if present
      final cleanText = _extractJsonFromMarkdown(text);
      final List<dynamic> phraseList = jsonDecode(cleanText);
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
    Either<Failure, ({List<Vocabulary> vocabularies, List<Phrase> phrases})>
  >
  fetchDailyLessons() async {
    try {
      final response = await dio.post(
        _geminiEndpoint,
        options: Options(
          headers: {
            'x-goog-api-key': apiKey,
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'contents': [
            {
              'parts': [
                {
                  'text':
                      'You are an English teacher. Provide both vocabulary words and phrases for daily learning. Respond in JSON format with two arrays: vocabularies and phrases. Each vocabulary should have English and Persian translations, and each phrase should have English and Persian translations. Format: {"vocabularies": [{"english": "...", "persian": "..."}], "phrases": [{"english": "...", "persian": "..."}]}',
                },
              ],
            },
          ],
        },
      );
      final text =
          response.data['candidates'][0]['content']['parts'][0]['text'];
      log(response.data.toString());

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

      return right((vocabularies: vocabularies, phrases: phrases));
    } catch (e) {
      log(e.toString());
      return left(
        ServerFailure('Failed to fetch daily lessons: ${e.toString()}'),
      );
    }
  }
}
