// complete_course_usecase.dart
// Use case for completing a course in the daily lessons feature
// Handles course completion and automatic unlocking of next course

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/daily_lessons_repository.dart';

/// Use case for completing a course
/// Handles the business logic for course completion and unlocking next course
class CompleteCourseUseCase {
  final DailyLessonsRepository _repository;

  /// Constructor
  /// @param repository Daily lessons repository
  CompleteCourseUseCase({required DailyLessonsRepository repository})
    : _repository = repository;

  /// Completes a course and unlocks the next one
  /// @param pathId The ID of the learning path
  /// @param courseNumber The course number to complete (1-20)
  /// @return Either Failure or void
  Future<Either<Failure, void>> call(String pathId, int courseNumber) async {
    // Validate inputs
    if (pathId.isEmpty) {
      return left(ValidationFailure('Path ID cannot be empty'));
    }

    if (courseNumber < 1 || courseNumber > 20) {
      return left(ValidationFailure('Course number must be between 1 and 20'));
    }

    // Complete the course
    return await _repository.completeCourse(pathId, courseNumber);
  }
}
