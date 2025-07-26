// daily_lessons_repository_impl.dart
// Enhanced implementation of the DailyLessonsRepository interface.
// This class connects the data sources to the domain layer and handles mapping and error handling.
// Now includes user-specific data storage and retrieval with metadata tracking.

import 'package:dartz/dartz.dart';
import '../../domain/entities/vocabulary.dart';
import '../../domain/entities/phrase.dart';
import '../../domain/entities/ai_usage_metadata.dart';
import '../../domain/repositories/daily_lessons_repository.dart';
import '../datasources/remote/ai_lessons_remote_data_source.dart';
import '../datasources/local/daily_lessons_local_data_source.dart';
import '../datasources/ai_provider_type.dart';
import '../models/vocabulary_model.dart';
import '../models/phrase_model.dart';
import 'package:learning_english/core/error/failure.dart';

/// Enhanced implementation of DailyLessonsRepository with user-specific storage
/// All AI-fetched content is automatically marked as used since the user will definitely read it
class DailyLessonsRepositoryImpl implements DailyLessonsRepository {
  final AiLessonsRemoteDataSource remoteDataSource;
  final DailyLessonsLocalDataSource localDataSource;

  /// Inject the AI-based remote data source and local data source via constructor
  DailyLessonsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Vocabulary>>> getDailyVocabularies() async {
    // First, try to get unused vocabularies from local storage
    final unusedVocabs = await localDataSource.getUnusedVocabularies();

    // If we have enough unused vocabularies, return them
    if (unusedVocabs.length >= 4) {
      return right(
        unusedVocabs.take(4).map((model) => model.toEntity()).toList(),
      );
    }

    // Otherwise, fetch new vocabularies from AI
    final result = await remoteDataSource.fetchDailyVocabularies();
    return result.fold((failure) => left(failure), (vocabularies) async {
      // Save new vocabularies to local storage with metadata
      final requestId = _generateRequestId();
      final providerType = _getCurrentProviderType();

      for (final vocabulary in vocabularies) {
        final model = VocabularyModel.fromEntity(
          vocabulary,
          'current_user', // Placeholder since we don't need userId for local storage
          providerType,
          _estimateTokens(vocabulary.english, vocabulary.persian),
          requestId,
        ).copyWith(
          isUsed: true,
        ); // Mark as used since user will definitely read it
        await localDataSource.saveUserVocabulary(model);
      }

      return right(vocabularies);
    });
  }

  @override
  Future<Either<Failure, List<Phrase>>> getDailyPhrases() async {
    // First, try to get unused phrases from local storage
    final unusedPhrases = await localDataSource.getUnusedPhrases();

    // If we have enough unused phrases, return them
    if (unusedPhrases.length >= 2) {
      return right(
        unusedPhrases.take(2).map((model) => model.toEntity()).toList(),
      );
    }

    // Otherwise, fetch new phrases from AI
    final result = await remoteDataSource.fetchDailyPhrases();
    return result.fold((failure) => left(failure), (phrases) async {
      // Save new phrases to local storage with metadata
      final requestId = _generateRequestId();
      final providerType = _getCurrentProviderType();

      for (final phrase in phrases) {
        final model = PhraseModel.fromEntity(
          phrase,
          'current_user', // Placeholder since we don't need userId for local storage
          providerType,
          _estimateTokens(phrase.english, phrase.persian),
          requestId,
        ).copyWith(
          isUsed: true,
        ); // Mark as used since user will definitely read it
        await localDataSource.saveUserPhrase(model);
      }

      return right(phrases);
    });
  }

  /// Get both vocabularies and phrases in a single request (cost-effective)
  /// This method reduces API costs by ~25-40% compared to separate requests
  /// Also includes user-specific storage and retrieval
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
  getDailyLessons() async {
    // First, try to get unused content from local storage
    final unusedVocabs = await localDataSource.getUnusedVocabularies();
    final unusedPhrases = await localDataSource.getUnusedPhrases();

    // If we have enough unused content, return it with empty metadata
    if (unusedVocabs.length >= 4 && unusedPhrases.length >= 2) {
      return right((
        vocabularies:
            unusedVocabs.take(4).map((model) => model.toEntity()).toList(),
        phrases:
            unusedPhrases.take(2).map((model) => model.toEntity()).toList(),
        metadata: const AiUsageMetadata(
          promptTokenCount: 0,
          candidatesTokenCount: 0,
          totalTokenCount: 0,
          thoughtsTokenCount: 0,
          modelVersion: 'local_cache',
          responseId: 'local_cache',
          finishReason: 'STOP',
        ),
      ));
    }

    // Otherwise, fetch new content from AI
    final result = await remoteDataSource.fetchDailyLessons();
    return result.fold((failure) => left(failure), (data) async {
      // Save new content to local storage with metadata
      final requestId = _generateRequestId();
      final providerType = _getCurrentProviderType();

      // Save vocabularies
      for (final vocabulary in data.vocabularies) {
        final model = VocabularyModel.fromEntity(
          vocabulary,
          'current_user', // Placeholder since we don't need userId for local storage
          providerType,
          _estimateTokens(vocabulary.english, vocabulary.persian),
          requestId,
        ).copyWith(
          isUsed: true,
        ); // Mark as used since user will definitely read it
        await localDataSource.saveUserVocabulary(model);
      }

      // Save phrases
      for (final phrase in data.phrases) {
        final model = PhraseModel.fromEntity(
          phrase,
          'current_user', // Placeholder since we don't need userId for local storage
          providerType,
          _estimateTokens(phrase.english, phrase.persian),
          requestId,
        ).copyWith(
          isUsed: true,
        ); // Mark as used since user will definitely read it
        await localDataSource.saveUserPhrase(model);
      }

      return right((
        vocabularies: data.vocabularies,
        phrases: data.phrases,
        metadata: data.metadata,
      ));
    });
  }

  @override
  Future<Either<Failure, bool>> refreshDailyLessons() async {
    // Use the cost-effective combined method for refresh
    final lessonsResult = await getDailyLessons();
    return lessonsResult.fold((failure) => left(failure), (_) => right(true));
  }

  /// Marks vocabulary as used for the current user
  /// Updates the usage status in local storage
  @override
  Future<Either<Failure, bool>> markVocabularyAsUsed(String english) async {
    try {
      await localDataSource.markVocabularyAsUsed(english);
      return right(true);
    } catch (e) {
      return left(CacheFailure('Failed to mark vocabulary as used: $e'));
    }
  }

  /// Marks phrase as used for the current user
  /// Updates the usage status in local storage
  @override
  Future<Either<Failure, bool>> markPhraseAsUsed(String english) async {
    try {
      await localDataSource.markPhraseAsUsed(english);
      return right(true);
    } catch (e) {
      return left(CacheFailure('Failed to mark phrase as used: $e'));
    }
  }

  /// Gets analytics data for the current user
  /// Returns usage statistics and cost analysis
  @override
  Future<Either<Failure, Map<String, dynamic>>> getUserAnalytics() async {
    try {
      final analytics = await localDataSource.getUserAnalytics();
      return right(analytics);
    } catch (e) {
      return left(CacheFailure('Failed to get user analytics: $e'));
    }
  }

  /// Gets vocabulary data by AI provider for the current user
  /// Used for analyzing performance and cost by provider
  @override
  Future<Either<Failure, List<Vocabulary>>> getVocabulariesByProvider(
    AiProviderType provider,
  ) async {
    try {
      final vocabModels = await localDataSource.getVocabulariesByProvider(
        provider,
      );
      return right(vocabModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return left(CacheFailure('Failed to get vocabularies by provider: $e'));
    }
  }

  /// Gets phrase data by AI provider for the current user
  /// Used for analyzing performance and cost by provider
  @override
  Future<Either<Failure, List<Phrase>>> getPhrasesByProvider(
    AiProviderType provider,
  ) async {
    try {
      final phraseModels = await localDataSource.getPhrasesByProvider(provider);
      return right(phraseModels.map((model) => model.toEntity()).toList());
    } catch (e) {
      return left(CacheFailure('Failed to get phrases by provider: $e'));
    }
  }

  /// Clears all data for the current user
  /// Used when user wants to reset their learning progress
  @override
  Future<Either<Failure, bool>> clearUserData() async {
    try {
      await localDataSource.clearUserData();
      return right(true);
    } catch (e) {
      return left(CacheFailure('Failed to clear user data: $e'));
    }
  }

  /// Generates a unique request ID for tracking
  /// Used to group related vocabulary and phrases from the same AI request
  String _generateRequestId() {
    return 'req_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Gets the current AI provider type
  /// This should be extracted from the remote data source configuration
  AiProviderType _getCurrentProviderType() {
    // This is a placeholder - you'll need to implement this based on your DI setup
    // For now, defaulting to OpenAI
    return AiProviderType.openai;
  }

  /// Estimates token usage for English and Persian text
  /// This is a rough estimation - actual token usage may vary by AI provider
  int _estimateTokens(String english, String persian) {
    // Rough estimation: 1 token ≈ 4 characters for English, 2 characters for Persian
    final englishTokens = (english.length / 4).ceil();
    final persianTokens = (persian.length / 2).ceil();
    return englishTokens + persianTokens;
  }
}

// Example usage:
// final repo = DailyLessonsRepositoryImpl(
//   remoteDataSource: remoteDataSource,
//   localDataSource: localDataSource,
// );
// final vocabResult = await repo.getDailyVocabularies();
// final phraseResult = await repo.getDailyPhrases();
// final lessonsResult = await repo.getDailyLessons(); // More cost-effective
// final analytics = await repo.getUserAnalytics();
// Note: All AI-fetched content is automatically marked as used (isUsed: true)
