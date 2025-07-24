// get_learning_focus_options_usecase.dart
// Use case for getting all available learning focus options.
//
// Usage Example:
//   final result = await useCase(NoParams());
//   result.fold((failure) => ..., (options) => ...);
//
// This use case retrieves all learning focus options from the repository.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../entities/learning_focus.dart';
import '../repositories/learning_focus_repository.dart';

class GetLearningFocusOptionsUseCase implements UseCase<List<LearningFocus>, NoParams> {
  final LearningFocusRepository repository;

  GetLearningFocusOptionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<LearningFocus>>> call(NoParams params) {
    return repository.getLearningFocusOptions();
  }
}
