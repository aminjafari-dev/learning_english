// courses_repository.dart
// Domain repository interface for courses operations
// Defines the contract for courses management

import 'package:dartz/dartz.dart';
import '../../../../../core/error/failure.dart';
import '../entities/vocabulary.dart';
import '../entities/phrase.dart';
import '../../../learning_paths/domain/entities/learning_path.dart';

/// Repository interface for courses operations
/// Defines the contract for courses management
abstract class CoursesRepository {
  /// Gets course-specific lessons for a learning path course
  /// @param pathId The learning path ID
  /// @param courseNumber The course number
  /// @param learningPath The learning path entity
  /// @return Either Failure or tuple of vocabularies and phrases
  Future<
    Either<Failure, ({List<Vocabulary> vocabularies, List<Phrase> phrases})>
  >
  getCourseLessons(String pathId, int courseNumber, LearningPath learningPath);

  /// Checks if course content exists for a specific course
  /// @param pathId The learning path ID
  /// @param courseNumber The course number
  /// @return Either Failure or boolean indicating if content exists
  Future<Either<Failure, bool>> hasCourseContent(
    String pathId,
    int courseNumber,
  );

  /// Saves course content for a specific course
  /// @param pathId The learning path ID
  /// @param courseNumber The course number
  /// @param vocabularies List of vocabularies to save
  /// @param phrases List of phrases to save
  /// @return Either Failure or void
  Future<Either<Failure, void>> saveCourseContent(
    String pathId,
    int courseNumber,
    List<Vocabulary> vocabularies,
    List<Phrase> phrases,
  );

  /// Completes a course and unlocks the next one
  /// @param pathId The learning path ID
  /// @param courseNumber The course number to complete
  /// @return Either Failure or void
  Future<Either<Failure, void>> completeCourse(String pathId, int courseNumber);
}
