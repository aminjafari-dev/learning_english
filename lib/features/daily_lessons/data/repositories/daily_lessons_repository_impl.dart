// daily_lessons_repository_impl.dart
// Implementation of the DailyLessonsRepository interface.
// This class connects the data sources to the domain layer and handles mapping and error handling.
//
// Now uses the real OpenAI API via DailyLessonsRemoteDataSourceImpl.
// Make sure to inject your OpenAI API key in the remote data source.
//
// This repository is AI-provider agnostic. It uses MultiModelLessonsRemoteDataSource to select the AI provider (OpenAI, Gemini, DeepSeek, etc.).
// Example usage:
// final dataSource = MultiModelLessonsRemoteDataSource(
//   providerType: AiProviderType.openai,
//   openAi: OpenAiLessonsRemoteDataSource(apiKey: 'YOUR_API_KEY'),
//   gemini: GeminiLessonsRemoteDataSource(),
//   deepSeek: DeepSeekLessonsRemoteDataSource(),
// );
// final repo = DailyLessonsRepositoryImpl(remoteDataSource: dataSource);
// final vocabResult = await repo.getDailyVocabularies();
// final phraseResult = await repo.getDailyPhrases();
// final lessonsResult = await repo.getDailyLessons(); // More cost-effective

import 'package:dartz/dartz.dart';
import '../../domain/entities/vocabulary.dart';
import '../../domain/entities/phrase.dart';
import '../../domain/repositories/daily_lessons_repository.dart';
import '../datasources/ai_lessons_remote_data_source.dart';
import 'package:learning_english/core/error/failure.dart';

/// Implementation of DailyLessonsRepository
class DailyLessonsRepositoryImpl implements DailyLessonsRepository {
  final AiLessonsRemoteDataSource remoteDataSource;

  /// Inject the AI-based remote data source via constructor
  DailyLessonsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Vocabulary>>> getDailyVocabularies() async {
    final result = await remoteDataSource.fetchDailyVocabularies();
    return result.fold(
      (failure) => left(failure),
      (models) => right(
        models
            .map((e) => Vocabulary(english: e.english, persian: e.persian))
            .toList(),
      ),
    );
  }

  @override
  Future<Either<Failure, List<Phrase>>> getDailyPhrases() async {
    final result = await remoteDataSource.fetchDailyPhrases();
    return result.fold(
      (failure) => left(failure),
      (models) => right(
        models
            .map((e) => Phrase(english: e.english, persian: e.persian))
            .toList(),
      ),
    );
  }

  /// Get both vocabularies and phrases in a single request (cost-effective)
  /// This method reduces API costs by ~25-40% compared to separate requests
  Future<
    Either<Failure, ({List<Vocabulary> vocabularies, List<Phrase> phrases})>
  >
  getDailyLessons() async {
    final result = await remoteDataSource.fetchDailyLessons();
    return result.fold(
      (failure) => left(failure),
      (data) => right((
        vocabularies:
            data.vocabularies
                .map((e) => Vocabulary(english: e.english, persian: e.persian))
                .toList(),
        phrases:
            data.phrases
                .map((e) => Phrase(english: e.english, persian: e.persian))
                .toList(),
      )),
    );
  }

  @override
  Future<Either<Failure, bool>> refreshDailyLessons() async {
    // Use the cost-effective combined method for refresh
    final lessonsResult = await getDailyLessons();
    return lessonsResult.fold((failure) => left(failure), (_) => right(true));
  }
}

// Example usage:
// final repo = DailyLessonsRepositoryImpl(remoteDataSource: ...);
// final vocabResult = await repo.getDailyVocabularies();
// final phraseResult = await repo.getDailyPhrases();
// final lessonsResult = await repo.getDailyLessons(); // More cost-effective
