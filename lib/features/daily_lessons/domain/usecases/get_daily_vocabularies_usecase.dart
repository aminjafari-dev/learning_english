// get_daily_vocabularies_usecase.dart
// Use case for fetching daily vocabularies, extends the base UseCase class.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/core/error/failure.dart';
import '../entities/vocabulary.dart';
import '../repositories/daily_lessons_repository.dart';

/// Use case for getting daily vocabularies
class GetDailyVocabulariesUseCase extends UseCase<List<Vocabulary>, NoParams> {
  final DailyLessonsRepository repository;

  /// Inject the repository via constructor
  GetDailyVocabulariesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Vocabulary>>> call(NoParams params) async {
    return await repository.getDailyVocabularies();
  }
}

// Example usage:
// final useCase = GetDailyVocabulariesUseCase(repo);
// final result = await useCase(NoParams());
