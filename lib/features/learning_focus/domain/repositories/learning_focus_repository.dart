// learning_focus_repository.dart
// Repository interface for learning focus operations.
//
// Usage Example:
//   final result = await repository.saveUserLearningFocus(userFocus);
//   result.fold((failure) => ..., (success) => ...);
//
// This interface defines the contract for learning focus data operations.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import '../entities/learning_focus.dart';
import '../entities/user_learning_focus.dart';

abstract class LearningFocusRepository {
  /// Gets all available learning focus options
  Future<Either<Failure, List<LearningFocus>>> getLearningFocusOptions();

  /// Saves the user's selected learning focus preferences
  Future<Either<Failure, void>> saveUserLearningFocus(UserLearningFocus userLearningFocus);

  /// Gets the user's saved learning focus preferences
  Future<Either<Failure, UserLearningFocus?>> getUserLearningFocus(String userId);

  /// Updates the user's learning focus preferences
  Future<Either<Failure, void>> updateUserLearningFocus(UserLearningFocus userLearningFocus);
}
