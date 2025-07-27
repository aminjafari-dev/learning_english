// mark_vocabulary_as_used_usecase.dart
// Use case for marking vocabulary as used by the user.
// This prevents the same vocabulary from being suggested again to the same user.

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/daily_lessons_repository.dart';

/// Use case for marking vocabulary as used
/// Prevents duplicate vocabulary suggestions for the same user
class MarkVocabularyAsUsedUseCase implements UseCase<bool, String> {
  final DailyLessonsRepository repository;

  MarkVocabularyAsUsedUseCase(this.repository);

  /// Marks a vocabulary as used by the current user
  /// @param english The English text of the vocabulary to mark as used
  /// @return Either a Failure or true if successful
  @override
  Future<Either<Failure, bool>> call(String english) async {
    try {
      return await repository.markVocabularyAsUsed(english);
    } catch (e) {
      return Left(
        ServerFailure('Failed to mark vocabulary as used: ${e.toString()}'),
      );
    }
  }
}

// Example usage:
// final useCase = MarkVocabularyAsUsedUseCase(repository);
// final result = await useCase('Perseverance');
// result.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (success) => print('Vocabulary marked as used successfully'),
// );
