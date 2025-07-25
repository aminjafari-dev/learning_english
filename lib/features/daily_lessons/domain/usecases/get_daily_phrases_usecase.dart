// get_daily_phrases_usecase.dart
// Use case for fetching daily phrases, extends the base UseCase class.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/core/error/failure.dart';
import '../entities/phrase.dart';
import '../repositories/daily_lessons_repository.dart';

/// Use case for getting daily phrases
class GetDailyPhrasesUseCase extends UseCase<List<Phrase>, NoParams> {
  final DailyLessonsRepository repository;

  /// Inject the repository via constructor
  GetDailyPhrasesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Phrase>>> call(NoParams params) async {
    return await repository.getDailyPhrases();
  }
}

// Example usage:
// final useCase = GetDailyPhrasesUseCase(repo);
// final result = await useCase(NoParams());
