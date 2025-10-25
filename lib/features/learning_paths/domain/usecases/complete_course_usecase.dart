// complete_course_usecase.dart
// Use case for completing a course
// Handles the business logic for course completion and progression

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/learning_paths_repository.dart';

/// Use case for completing a course
/// Handles the business logic for course completion and unlocking next course
class CompleteCourseUseCase {
  final LearningPathsRepository _repository;

  /// Constructor
  /// @param repository Learning paths repository
  CompleteCourseUseCase({required LearningPathsRepository repository})
    : _repository = repository;

  /// Completes a course and unlocks the next one
  /// @param courseNumber The course number to complete (1-20)
  /// @return Either Failure or void
  Future<Either<Failure, void>> call(int courseNumber) async {
    // Validate course number
    if (courseNumber < 1 || courseNumber > 20) {
      return left(ValidationFailure('Course number must be between 1 and 20'));
    }

    // Complete the course
    return await _repository.completeCourse(courseNumber);
  }
}
