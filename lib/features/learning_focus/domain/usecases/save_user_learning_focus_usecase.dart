// save_user_learning_focus_usecase.dart
// Use case for saving user's learning focus preferences.
//
// Usage Example:
//   final result = await useCase(SaveUserLearningFocusParams(userFocus));
//   result.fold((failure) => ..., (success) => ...);
//
// This use case saves the user's selected learning focus preferences.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../entities/user_learning_focus.dart';
import '../repositories/learning_focus_repository.dart';

class SaveUserLearningFocusUseCase implements UseCase<void, SaveUserLearningFocusParams> {
  final LearningFocusRepository repository;

  SaveUserLearningFocusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveUserLearningFocusParams params) {
    return repository.saveUserLearningFocus(params.userLearningFocus);
  }
}

class SaveUserLearningFocusParams {
  final UserLearningFocus userLearningFocus;

  SaveUserLearningFocusParams({required this.userLearningFocus});
}
