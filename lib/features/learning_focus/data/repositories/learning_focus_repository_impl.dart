// learning_focus_repository_impl.dart
// Implementation of LearningFocusRepository using local and remote data sources.
//
// Usage Example:
//   final repository = LearningFocusRepositoryImpl(
//     localDataSource: localDataSource,
//     remoteDataSource: remoteDataSource,
//   );
//   final result = await repository.getLearningFocusOptions();
//
// This repository handles data operations for learning focus functionality.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import '../../domain/entities/learning_focus.dart';
import '../../domain/entities/user_learning_focus.dart';
import '../../domain/repositories/learning_focus_repository.dart';
import '../datasources/learning_focus_local_data_source.dart';
import '../datasources/learning_focus_remote_data_source.dart';
import '../models/user_learning_focus_model.dart';

class LearningFocusRepositoryImpl implements LearningFocusRepository {
  final LearningFocusLocalDataSource localDataSource;
  final LearningFocusRemoteDataSource remoteDataSource;

  LearningFocusRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<LearningFocus>>> getLearningFocusOptions() async {
    try {
      final models = await localDataSource.getLearningFocusOptions();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserLearningFocus(UserLearningFocus userLearningFocus) async {
    try {
      final model = UserLearningFocusModel.fromEntity(userLearningFocus);
      await remoteDataSource.saveUserLearningFocus(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserLearningFocus?>> getUserLearningFocus(String userId) async {
    try {
      final model = await remoteDataSource.getUserLearningFocus(userId);
      final entity = model?.toEntity();
      return Right(entity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserLearningFocus(UserLearningFocus userLearningFocus) async {
    try {
      final model = UserLearningFocusModel.fromEntity(userLearningFocus);
      await remoteDataSource.updateUserLearningFocus(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
