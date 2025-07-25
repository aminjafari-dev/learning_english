// ai_lessons_remote_data_source.dart
// Abstract interface for AI-based lessons data sources (OpenAI, Gemini, DeepSeek, etc.)
// Implement this interface for each provider.

import 'package:dartz/dartz.dart';
import '../../domain/entities/vocabulary.dart';
import '../../domain/entities/phrase.dart';
import 'package:learning_english/core/error/failure.dart';

/// Abstract interface for AI-based lessons data sources
abstract class AiLessonsRemoteDataSource {
  /// Fetches daily vocabularies from the AI provider
  /// @deprecated Use fetchDailyLessons() instead for better cost efficiency
  Future<Either<Failure, List<Vocabulary>>> fetchDailyVocabularies();

  /// Fetches daily phrases from the AI provider
  /// @deprecated Use fetchDailyLessons() instead for better cost efficiency
  Future<Either<Failure, List<Phrase>>> fetchDailyPhrases();

  /// Fetches both daily vocabularies and phrases in a single request
  /// This method is more cost-effective than making separate requests
  /// Returns a tuple containing vocabularies and phrases
  Future<
    Either<Failure, ({List<Vocabulary> vocabularies, List<Phrase> phrases})>
  >
  fetchDailyLessons();
}
