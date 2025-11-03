// get_courses_usecase.dart
// Use case for getting personalized courses.
// This generates vocabularies and phrases based on user preferences.
// Now saves generated content to local storage for tracking and analytics.
//
// Usage:
// final useCase = GetCoursesUseCase(repository);
// final preferences = UserPreferences(level: Level.intermediate, focusAreas: ['business']);
// final result = await useCase.call(preferences);
// result.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (data) => print('New vocabularies: ${data.vocabularies.length}, New phrases: ${data.phrases.length}'),
// );

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../entities/vocabulary.dart';
import '../entities/phrase.dart';
import '../entities/user_preferences.dart';
import '../repositories/courses_repository.dart';

/// Use case for getting personalized courses
/// Generates vocabularies and phrases based on user preferences
/// Saves generated content to local storage for tracking and analytics
class GetCoursesUseCase
    implements
        UseCase<
          ({List<Vocabulary> vocabularies, List<Phrase> phrases}),
          UserPreferences
        > {
  final CoursesRepository repository;

  /// Constructor
  /// @param repository Courses repository
  GetCoursesUseCase(this.repository);

  @override
  Future<
    Either<Failure, ({List<Vocabulary> vocabularies, List<Phrase> phrases})>
  >
  call(UserPreferences preferences) async {
    try {
      // Generate personalized lessons based on user preferences
      final result = await repository.getPersonalizedCourses(preferences);

      return result.fold(
        (failure) => left(failure),
        (data) =>
            right((vocabularies: data.vocabularies, phrases: data.phrases)),
      );
    } catch (e) {
      return left(
        ServerFailure('Failed to get courses: ${e.toString()}'),
      );
    }
  }
}

// Example usage:
// final useCase = GetCoursesUseCase(getIt<CoursesRepository>());
// final preferences = UserPreferences(
//   level: Level.intermediate,
//   focusAreas: ['business', 'technology']
// );
// final result = await useCase.call(preferences);
// result.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (data) {
//     print('New vocabularies: ${data.vocabularies.length}');
//     print('New phrases: ${data.phrases.length}');
//   },
// );
