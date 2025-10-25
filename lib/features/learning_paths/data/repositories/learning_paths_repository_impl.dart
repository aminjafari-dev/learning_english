// learning_paths_repository_impl.dart
// Implementation of LearningPathsRepository
// Coordinates between local storage and business logic

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/learning_path.dart';
import '../../domain/entities/sub_category.dart';
import '../../domain/repositories/learning_paths_repository.dart';
import '../datasources/local/learning_paths_local_data_source.dart';
import '../../../level_selection/domain/entities/user_profile.dart';

/// Implementation of LearningPathsRepository
/// Handles learning path operations using local storage
class LearningPathsRepositoryImpl implements LearningPathsRepository {
  final LearningPathsLocalDataSource _localDataSource;

  /// Constructor
  /// @param localDataSource Local data source for learning paths
  LearningPathsRepositoryImpl({
    required LearningPathsLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<Either<Failure, LearningPath>> createLearningPath({
    required Level level,
    required List<String> focusAreas,
    required SubCategory subCategory,
  }) async {
    try {
      // Generate unique ID for the learning path
      final pathId = 'path_${DateTime.now().millisecondsSinceEpoch}';

      // Create the learning path with 20 courses
      final learningPath = LearningPath.create(
        id: pathId,
        level: level,
        focusAreas: focusAreas,
        subCategory: subCategory,
      );

      // Save to local storage
      await _localDataSource.saveLearningPath(learningPath);

      print(
        '✅ [LEARNING_PATHS_REPO] Learning path created: ${learningPath.title}',
      );
      return right(learningPath);
    } catch (e) {
      print('❌ [LEARNING_PATHS_REPO] Error creating learning path: $e');
      return left(
        ServerFailure('Failed to create learning path: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, LearningPath?>> getActiveLearningPath() async {
    try {
      final learningPath = await _localDataSource.getActiveLearningPath();

      if (learningPath != null) {
        print(
          '✅ [LEARNING_PATHS_REPO] Retrieved active learning path: ${learningPath.title}',
        );
      } else {
        print('ℹ️ [LEARNING_PATHS_REPO] No active learning path found');
      }

      return right(learningPath);
    } catch (e) {
      print('❌ [LEARNING_PATHS_REPO] Error getting active learning path: $e');
      return left(
        ServerFailure('Failed to get active learning path: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> completeCourse(int courseNumber) async {
    try {
      // Mark the course as completed
      await _localDataSource.updateCourseProgress(courseNumber, true);

      // Get the active learning path to check if we need to unlock the next course
      final learningPathResult = await getActiveLearningPath();

      return learningPathResult.fold((failure) => left(failure), (
        learningPath,
      ) async {
        if (learningPath != null) {
          // Check if there's a next course to unlock
          final nextCourseNumber = learningPath.nextCourseToUnlock;
          if (nextCourseNumber != null && nextCourseNumber <= 20) {
            await _localDataSource.unlockCourse(nextCourseNumber);
            print(
              '✅ [LEARNING_PATHS_REPO] Course $courseNumber completed, unlocked course $nextCourseNumber',
            );
          } else {
            print(
              '✅ [LEARNING_PATHS_REPO] Course $courseNumber completed, no more courses to unlock',
            );
          }
        }
        return right(null);
      });
    } catch (e) {
      print('❌ [LEARNING_PATHS_REPO] Error completing course: $e');
      return left(ServerFailure('Failed to complete course: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLearningPath() async {
    try {
      await _localDataSource.deleteActiveLearningPath();
      print('✅ [LEARNING_PATHS_REPO] Learning path deleted');
      return right(null);
    } catch (e) {
      print('❌ [LEARNING_PATHS_REPO] Error deleting learning path: $e');
      return left(
        ServerFailure('Failed to delete learning path: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> hasActiveLearningPath() async {
    try {
      final hasPath = await _localDataSource.hasActiveLearningPath();
      return right(hasPath);
    } catch (e) {
      print(
        '❌ [LEARNING_PATHS_REPO] Error checking for active learning path: $e',
      );
      return left(
        ServerFailure(
          'Failed to check for active learning path: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, int>?>> getProgressStatistics() async {
    try {
      final statistics = await _localDataSource.getProgressStatistics();
      return right(statistics);
    } catch (e) {
      print('❌ [LEARNING_PATHS_REPO] Error getting progress statistics: $e');
      return left(
        ServerFailure('Failed to get progress statistics: ${e.toString()}'),
      );
    }
  }
}
