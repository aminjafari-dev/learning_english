// clear_user_data_usecase.dart
// Use case for clearing all user data.
// Used when user wants to reset their learning progress.

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/daily_lessons_repository.dart';

/// Use case for clearing all user data
/// Resets the user's learning progress by removing all stored content
class ClearUserDataUseCase implements UseCase<bool, void> {
  final DailyLessonsRepository repository;

  ClearUserDataUseCase(this.repository);

  /// Clears all data for the current user
  /// @param params Not used (void parameter for consistency)
  /// @return Either a Failure or true if successful
  @override
  Future<Either<Failure, bool>> call(void params) async {
    try {
      return await repository.clearUserData();
    } catch (e) {
      return Left(ServerFailure('Failed to clear user data: ${e.toString()}'));
    }
  }
}

// Example usage:
// final useCase = ClearUserDataUseCase(repository);
// final result = await useCase(null);
// result.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (success) => print('User data cleared successfully'),
// );
