// mark_phrase_as_used_usecase.dart
// Use case for marking phrase as used by the user.
// This prevents the same phrase from being suggested again to the same user.

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/daily_lessons_repository.dart';

/// Use case for marking phrase as used
/// Prevents duplicate phrase suggestions for the same user
class MarkPhraseAsUsedUseCase implements UseCase<bool, String> {
  final DailyLessonsRepository repository;

  MarkPhraseAsUsedUseCase(this.repository);

  /// Marks a phrase as used by the current user
  /// @param english The English text of the phrase to mark as used
  /// @return Either a Failure or true if successful
  @override
  Future<Either<Failure, bool>> call(String english) async {
    try {
      return await repository.markPhraseAsUsed(english);
    } catch (e) {
      return Left(
        ServerFailure('Failed to mark phrase as used: ${e.toString()}'),
      );
    }
  }
}

// Example usage:
// final useCase = MarkPhraseAsUsedUseCase(repository);
// final result = await useCase('I owe it to myself');
// result.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (success) => print('Phrase marked as used successfully'),
// );
