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
  Future<Either<Failure, List<LearningPath>>> getAllLearningPaths() async {
    try {
      final learningPaths = await _localDataSource.getAllLearningPaths();

      print(
        '✅ [LEARNING_PATHS_REPO] Retrieved ${learningPaths.length} learning paths',
      );

      return right(learningPaths);
    } catch (e) {
      print('❌ [LEARNING_PATHS_REPO] Error getting all learning paths: $e');
      return left(
        ServerFailure('Failed to get learning paths: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, LearningPath?>> getLearningPathById(
    String pathId,
  ) async {
    try {
      final learningPath = await _localDataSource.getLearningPathById(pathId);

      if (learningPath != null) {
        print(
          '✅ [LEARNING_PATHS_REPO] Retrieved learning path: ${learningPath.title}',
        );
      } else {
        print('ℹ️ [LEARNING_PATHS_REPO] Learning path not found: $pathId');
      }

      return right(learningPath);
    } catch (e) {
      print('❌ [LEARNING_PATHS_REPO] Error getting learning path by ID: $e');
      return left(
        ServerFailure('Failed to get learning path: ${e.toString()}'),
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
  Future<Either<Failure, void>> deleteLearningPath(String pathId) async {
    try {
      await _localDataSource.deleteLearningPath(pathId);
      print('✅ [LEARNING_PATHS_REPO] Learning path $pathId deleted');
      return right(null);
    } catch (e) {
      print('❌ [LEARNING_PATHS_REPO] Error deleting learning path: $e');
      return left(
        ServerFailure('Failed to delete learning path: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> hasLearningPaths() async {
    try {
      final hasPaths = await _localDataSource.hasLearningPaths();
      return right(hasPaths);
    } catch (e) {
      print('❌ [LEARNING_PATHS_REPO] Error checking for learning paths: $e');
      return left(
        ServerFailure('Failed to check for learning paths: ${e.toString()}'),
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
  Future<Either<Failure, Map<String, int>?>> getProgressStatistics(
    String pathId,
  ) async {
    try {
      final statistics = await _localDataSource.getProgressStatistics(pathId);
      return right(statistics);
    } catch (e) {
      print('❌ [LEARNING_PATHS_REPO] Error getting progress statistics: $e');
      return left(
        ServerFailure('Failed to get progress statistics: ${e.toString()}'),
      );
    }
  }
}
