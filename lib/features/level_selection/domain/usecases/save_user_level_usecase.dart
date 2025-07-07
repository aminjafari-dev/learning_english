// This file defines the SaveUserLevelUseCase for saving user level.
// Usage: Called from the BLoC to persist the selected level.
// Example:
//   final result = await useCase('user123', Level.beginner);

import 'package:dartz/dartz.dart';
import '../entities/user_profile.dart';
import '../repositories/user_repository.dart';
import 'package:learning_english/core/error/failure.dart';

class SaveUserLevelUseCase {
  final UserRepository repository;

  SaveUserLevelUseCase(this.repository);

  /// Calls the repository to save the user's level
  Future<Either<Failure, void>> call(String userId, Level level) {
    return repository.saveUserLevel(userId, level);
  }
}
