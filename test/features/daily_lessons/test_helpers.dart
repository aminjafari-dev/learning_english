// test_helpers.dart
// Test helpers and utilities for daily lessons feature tests.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';
import 'package:learning_english/features/daily_lessons/presentation/bloc/daily_lessons_bloc.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/local/daily_lessons_local_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/ai_lessons_remote_data_source.dart';
import 'package:learning_english/features/daily_lessons/data/repositories/daily_lessons_repository_impl.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_daily_vocabularies_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_daily_phrases_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_daily_lessons_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/refresh_daily_lessons_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/mark_vocabulary_as_used_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/mark_phrase_as_used_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/get_user_analytics_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/usecases/clear_user_data_usecase.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/vocabulary.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/phrase.dart';
import 'package:learning_english/features/daily_lessons/domain/entities/ai_usage_metadata.dart';
import 'package:learning_english/features/daily_lessons/data/models/vocabulary_model.dart';
import 'package:learning_english/features/daily_lessons/data/models/phrase_model.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/ai_provider_type.dart';
import 'package:learning_english/core/error/failure.dart';

/// Test helper class for creating mock data and test scenarios
class DailyLessonsTestHelpers {
  /// Creates a sample vocabulary for testing
  static Vocabulary createSampleVocabulary({
    String english = 'Perseverance',
    String persian = 'پشتکار',
  }) {
    return Vocabulary(english: english, persian: persian);
  }

  /// Creates a sample phrase for testing
  static Phrase createSamplePhrase({
    String english = 'I owe it to myself',
    String persian = 'به خودم مدیونم',
  }) {
    return Phrase(english: english, persian: persian);
  }

  /// Creates a sample vocabulary model for testing
  static VocabularyModel createSampleVocabularyModel({
    String english = 'Perseverance',
    String persian = 'پشتکار',
    String userId = 'current_user',
    AiProviderType aiProvider = AiProviderType.openai,
    DateTime? createdAt,
    int tokensUsed = 30,
    String requestId = 'req_1',
    bool isUsed = false,
  }) {
    return VocabularyModel(
      english: english,
      persian: persian,
      userId: userId,
      aiProvider: aiProvider,
      createdAt: createdAt ?? DateTime.now(),
      tokensUsed: tokensUsed,
      requestId: requestId,
      isUsed: isUsed,
    );
  }

  /// Creates a sample phrase model for testing
  static PhraseModel createSamplePhraseModel({
    String english = 'I owe it to myself',
    String persian = 'به خودم مدیونم',
    String userId = 'current_user',
    AiProviderType aiProvider = AiProviderType.openai,
    DateTime? createdAt,
    int tokensUsed = 35,
    String requestId = 'req_1',
    bool isUsed = false,
  }) {
    return PhraseModel(
      english: english,
      persian: persian,
      userId: userId,
      aiProvider: aiProvider,
      createdAt: createdAt ?? DateTime.now(),
      tokensUsed: tokensUsed,
      requestId: requestId,
      isUsed: isUsed,
    );
  }

  /// Creates a list of sample vocabularies for testing
  static List<Vocabulary> createSampleVocabularies({int count = 4}) {
    return List.generate(
      count,
      (index) => createSampleVocabulary(
        english: 'Word ${index + 1}',
        persian: 'کلمه ${index + 1}',
      ),
    );
  }

  /// Creates a list of sample phrases for testing
  static List<Phrase> createSamplePhrases({int count = 2}) {
    return List.generate(
      count,
      (index) => createSamplePhrase(
        english: 'Phrase ${index + 1}',
        persian: 'عبارت ${index + 1}',
      ),
    );
  }

  /// Creates a list of sample vocabulary models for testing
  static List<VocabularyModel> createSampleVocabularyModels({int count = 4}) {
    return List.generate(
      count,
      (index) => createSampleVocabularyModel(
        english: 'Word ${index + 1}',
        persian: 'کلمه ${index + 1}',
        requestId: 'req_${index + 1}',
        tokensUsed: 30 + index,
      ),
    );
  }

  /// Creates a list of sample phrase models for testing
  static List<PhraseModel> createSamplePhraseModels({int count = 2}) {
    return List.generate(
      count,
      (index) => createSamplePhraseModel(
        english: 'Phrase ${index + 1}',
        persian: 'عبارت ${index + 1}',
        requestId: 'req_${index + 100}',
        tokensUsed: 35 + index,
      ),
    );
  }

  /// Creates sample analytics data for testing
  static Map<String, dynamic> createSampleAnalytics({
    int totalVocabularies = 10,
    int totalPhrases = 5,
    int totalTokens = 500,
    int usedVocabularies = 7,
    int usedPhrases = 3,
  }) {
    return {
      'totalVocabularies': totalVocabularies,
      'totalPhrases': totalPhrases,
      'totalTokens': totalTokens,
      'usedVocabularies': usedVocabularies,
      'usedPhrases': usedPhrases,
      'providerStats': {
        'AiProviderType.openai': {
          'vocabularies': 6,
          'phrases': 3,
          'tokensUsed': 300,
          'usedVocabularies': 4,
          'usedPhrases': 2,
        },
        'AiProviderType.gemini': {
          'vocabularies': 4,
          'phrases': 2,
          'tokensUsed': 200,
          'usedVocabularies': 3,
          'usedPhrases': 1,
        },
      },
    };
  }

  /// Populates local storage with test data
  static Future<void> populateLocalStorage(
    DailyLessonsLocalDataSource localDataSource, {
    int vocabularyCount = 4,
    int phraseCount = 2,
    bool markSomeAsUsed = true,
  }) async {
    final vocabularies = createSampleVocabularyModels(count: vocabularyCount);
    final phrases = createSamplePhraseModels(count: phraseCount);

    // Mark some as used if requested
    if (markSomeAsUsed) {
      for (int i = 0; i < vocabularies.length; i++) {
        if (i % 2 == 0) {
          vocabularies[i] = vocabularies[i].copyWith(isUsed: true);
        }
      }
      for (int i = 0; i < phrases.length; i++) {
        if (i % 2 == 0) {
          phrases[i] = phrases[i].copyWith(isUsed: true);
        }
      }
    }

    // Save to local storage
    for (final vocabulary in vocabularies) {
      await localDataSource.saveUserVocabulary(vocabulary);
    }
    for (final phrase in phrases) {
      await localDataSource.saveUserPhrase(phrase);
    }
  }

  /// Creates a test widget with BLoC provider
  static Widget createTestWidget({
    required Widget child,
    required DailyLessonsBloc bloc,
  }) {
    return MaterialApp(
      home: BlocProvider<DailyLessonsBloc>.value(value: bloc, child: child),
    );
  }

  /// Sets up test dependencies for daily lessons tests
  static Future<
    ({
      SharedPreferences prefs,
      DailyLessonsLocalDataSource localDataSource,
      DailyLessonsRepositoryImpl repository,
      DailyLessonsBloc bloc,
    })
  >
  setupTestDependencies() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();

    final localDataSource = DailyLessonsLocalDataSource(prefs);

    // Create a mock remote data source (you'll need to implement this based on your mocking strategy)
    // For now, we'll create a simple implementation
    final repository = DailyLessonsRepositoryImpl(
      remoteDataSource: MockAiLessonsRemoteDataSource(),
      localDataSource: localDataSource,
    );

    final getDailyVocabulariesUseCase = GetDailyVocabulariesUseCase(repository);
    final getDailyPhrasesUseCase = GetDailyPhrasesUseCase(repository);
    final getDailyLessonsUseCase = GetDailyLessonsUseCase(repository);
    final refreshDailyLessonsUseCase = RefreshDailyLessonsUseCase(repository);
    final markVocabularyAsUsedUseCase = MarkVocabularyAsUsedUseCase(repository);
    final markPhraseAsUsedUseCase = MarkPhraseAsUsedUseCase(repository);
    final getUserAnalyticsUseCase = GetUserAnalyticsUseCase(repository);
    final clearUserDataUseCase = ClearUserDataUseCase(repository);

    final bloc = DailyLessonsBloc(
      getDailyVocabulariesUseCase: getDailyVocabulariesUseCase,
      getDailyPhrasesUseCase: getDailyPhrasesUseCase,
      getDailyLessonsUseCase: getDailyLessonsUseCase,
      refreshDailyLessonsUseCase: refreshDailyLessonsUseCase,
      markVocabularyAsUsedUseCase: markVocabularyAsUsedUseCase,
      markPhraseAsUsedUseCase: markPhraseAsUsedUseCase,
      getUserAnalyticsUseCase: getUserAnalyticsUseCase,
      clearUserDataUseCase: clearUserDataUseCase,
    );

    return (
      prefs: prefs,
      localDataSource: localDataSource,
      repository: repository,
      bloc: bloc,
    );
  }

  /// Cleans up test dependencies
  static Future<void> cleanupTestDependencies({
    required SharedPreferences prefs,
    required DailyLessonsBloc bloc,
  }) async {
    await prefs.clear();
    bloc.close();
  }
}

/// Mock remote data source for testing
class MockAiLessonsRemoteDataSource implements AiLessonsRemoteDataSource {
  @override
  Future<Either<Failure, List<Vocabulary>>> fetchDailyVocabularies() async {
    // Default implementation - override in tests as needed
    throw UnimplementedError('Override this method in tests');
  }

  @override
  Future<Either<Failure, List<Phrase>>> fetchDailyPhrases() async {
    // Default implementation - override in tests as needed
    throw UnimplementedError('Override this method in tests');
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
  fetchDailyLessons() async {
    // Default implementation - override in tests as needed
    throw UnimplementedError('Override this method in tests');
  }
}

/// Test matchers for common assertions
class DailyLessonsMatchers {
  /// Matches a vocabulary with specific English text
  static Matcher hasVocabulary(String english) {
    return predicate((widget) {
      if (widget is Text) {
        return widget.data == english;
      }
      return false;
    }, 'contains vocabulary: $english');
  }

  /// Matches a phrase with specific English text
  static Matcher hasPhrase(String english) {
    return predicate((widget) {
      if (widget is Text) {
        return widget.data == english;
      }
      return false;
    }, 'contains phrase: $english');
  }

  /// Matches a loading indicator
  static Matcher isLoading() {
    return isA<CircularProgressIndicator>();
  }

  /// Matches an error message
  static Matcher hasError(String message) {
    return predicate((widget) {
      if (widget is Text) {
        return widget.data == message;
      }
      return false;
    }, 'contains error: $message');
  }
}
