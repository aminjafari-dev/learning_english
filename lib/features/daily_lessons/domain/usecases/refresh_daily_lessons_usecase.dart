// refresh_daily_lessons_usecase.dart
// Use case for refreshing all daily lesson content, extends the base UseCase class.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/core/error/failure.dart';
import '../repositories/daily_lessons_repository.dart';

/// Use case for refreshing daily lessons
class RefreshDailyLessonsUseCase extends UseCase<bool, NoParams> {
  final DailyLessonsRepository repository;

  /// Inject the repository via constructor
  RefreshDailyLessonsUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.refreshDailyLessons();
  }
}

// Example usage:
// final useCase = RefreshDailyLessonsUseCase(repo);
// final result = await useCase(NoParams());
