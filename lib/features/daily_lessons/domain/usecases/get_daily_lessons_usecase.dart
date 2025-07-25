// get_daily_lessons_usecase.dart
// Use case for fetching both daily vocabularies and phrases in a single request.
// This use case is more cost-effective than separate requests for vocabularies and phrases.
//
// Usage:
// final useCase = GetDailyLessonsUseCase(repository);
// final result = await useCase.call(NoParams());
// result.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (data) => print('Vocabularies: ${data.vocabularies.length}, Phrases: ${data.phrases.length}'),
// );

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../entities/vocabulary.dart';
import '../entities/phrase.dart';
import '../repositories/daily_lessons_repository.dart';

/// Use case for fetching both daily vocabularies and phrases in a single request
/// This approach reduces API costs by ~25-40% compared to separate requests
class GetDailyLessonsUseCase
    implements
        UseCase<
          ({List<Vocabulary> vocabularies, List<Phrase> phrases}),
          NoParams
        > {
  final DailyLessonsRepository repository;

  GetDailyLessonsUseCase(this.repository);

  @override
  Future<
    Either<Failure, ({List<Vocabulary> vocabularies, List<Phrase> phrases})>
  >
  call(NoParams params) async {
    return await repository.getDailyLessons();
  }
}
