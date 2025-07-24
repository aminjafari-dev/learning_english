// get_user_learning_focus_usecase.dart
// Use case for getting user's saved learning focus preferences.
//
// Usage Example:
//   final result = await useCase(GetUserLearningFocusParams('user123'));
//   result.fold((failure) => ..., (userFocus) => ...);
//
// This use case retrieves the user's saved learning focus preferences.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../entities/user_learning_focus.dart';
import '../repositories/learning_focus_repository.dart';

class GetUserLearningFocusUseCase implements UseCase<UserLearningFocus?, GetUserLearningFocusParams> {
  final LearningFocusRepository repository;

  GetUserLearningFocusUseCase(this.repository);

  @override
  Future<Either<Failure, UserLearningFocus?>> call(GetUserLearningFocusParams params) {
    return repository.getUserLearningFocus(params.userId);
  }
}

class GetUserLearningFocusParams {
  final String userId;

  GetUserLearningFocusParams({required this.userId});
}
