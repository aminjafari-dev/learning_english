 // daily_lessons_remote_data_source.dart
// This file defines the remote data source for fetching daily lessons, vocabularies, and phrases.
// Use this class to interact with remote APIs (e.g., OpenAI or your backend).

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import '../../domain/entities/vocabulary.dart';
import '../../domain/entities/phrase.dart';

/// Abstract class for the remote data source
abstract class DailyLessonsRemoteDataSource {
  /// Fetches daily vocabularies from the remote source (e.g., OpenAI)
  Future<Either<Failure, List<Vocabulary>>> fetchDailyVocabularies();

  /// Fetches daily phrases from the remote source (e.g., OpenAI)
  Future<Either<Failure, List<Phrase>>> fetchDailyPhrases();
}

/// Example implementation (simulate OpenAI integration)
class DailyLessonsRemoteDataSourceImpl implements DailyLessonsRemoteDataSource {
  @override
  Future<Either<Failure, List<Vocabulary>>> fetchDailyVocabularies() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return right([
      Vocabulary(english: 'Translation', persian: 'ترجمه'),
      Vocabulary(english: 'Lesson', persian: 'درس'),
      Vocabulary(english: 'Exercise', persian: 'تمرین'),
      Vocabulary(english: 'Exam', persian: 'امتحان'),
    ]);
  }

  @override
  Future<Either<Failure, List<Phrase>>> fetchDailyPhrases() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    return right([
      Phrase(english: 'Day by day it gets better', persian: 'امروز به امروز بهتر می شود'),
      Phrase(english: 'I owe it to myself', persian: 'به اون امیدوارم به اون امیدوارم'),
    ]);
  }
}

// Example usage:
// final dataSource = DailyLessonsRemoteDataSourceImpl();
// final vocabResult = await dataSource.fetchDailyVocabularies();
// final phraseResult = await dataSource.fetchDailyPhrases();
