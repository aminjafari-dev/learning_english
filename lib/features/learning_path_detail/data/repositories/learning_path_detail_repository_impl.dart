// learning_path_detail_repository_impl.dart
// Implementation of LearningPathDetailRepository
// Coordinates between local storage and business logic

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/learning_path.dart';
import '../../domain/repositories/learning_path_detail_repository.dart';
import '../datasources/local/learning_path_detail_local_data_source.dart';

/// Implementation of LearningPathDetailRepository
/// Handles learning path detail operations using local storage
class LearningPathDetailRepositoryImpl implements LearningPathDetailRepository {
  final LearningPathDetailLocalDataSource _localDataSource;

  /// Constructor
  /// @param localDataSource Local data source for learning path detail
  LearningPathDetailRepositoryImpl({
    required LearningPathDetailLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<Either<Failure, LearningPath?>> getLearningPathById(
    String pathId,
  ) async {
    try {
      final learningPath = await _localDataSource.getLearningPathById(pathId);

      if (learningPath != null) {
        print(
          '✅ [LEARNING_PATH_DETAIL_REPO] Retrieved learning path: ${learningPath.title}',
        );
      } else {
        print(
          'ℹ️ [LEARNING_PATH_DETAIL_REPO] Learning path not found: $pathId',
        );
      }

      return right(learningPath);
    } catch (e) {
      print(
        '❌ [LEARNING_PATH_DETAIL_REPO] Error getting learning path by ID: $e',
      );
      return left(
        ServerFailure('Failed to get learning path: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> completeCourse(
    String pathId,
    int courseNumber,
  ) async {
    try {
      // Mark the course as completed
      await _localDataSource.updateCourseProgress(pathId, courseNumber, true);

      // Get the learning path to check if we need to unlock the next course
      final learningPathResult = await getLearningPathById(pathId);

      return learningPathResult.fold((failure) => left(failure), (
        learningPath,
      ) async {
        if (learningPath != null) {
          // Check if there's a next course to unlock
          final nextCourseNumber = learningPath.nextCourseToUnlock;
          if (nextCourseNumber != null && nextCourseNumber <= 20) {
            await _localDataSource.unlockCourse(pathId, nextCourseNumber);
            print(
              '✅ [LEARNING_PATH_DETAIL_REPO] Course $courseNumber completed, unlocked course $nextCourseNumber',
            );
          } else {
            print(
              '✅ [LEARNING_PATH_DETAIL_REPO] Course $courseNumber completed, no more courses to unlock',
            );
          }
        }
        return right(null);
      });
    } catch (e) {
      print('❌ [LEARNING_PATH_DETAIL_REPO] Error completing course: $e');
      return left(ServerFailure('Failed to complete course: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLearningPath(String pathId) async {
    try {
      await _localDataSource.deleteLearningPath(pathId);
      print('✅ [LEARNING_PATH_DETAIL_REPO] Learning path $pathId deleted');
      return right(null);
    } catch (e) {
      print('❌ [LEARNING_PATH_DETAIL_REPO] Error deleting learning path: $e');
      return left(
        ServerFailure('Failed to delete learning path: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, int>?>> getProgressStatistics(
    String pathId,
  ) async {
    try {
      final statistics = await _localDataSource.getProgressStatistics(pathId);
      return right(statistics);
    } catch (e) {
      print(
        '❌ [LEARNING_PATH_DETAIL_REPO] Error getting progress statistics: $e',
      );
      return left(
        ServerFailure('Failed to get progress statistics: ${e.toString()}'),
      );
    }
  }
}
