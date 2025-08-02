// This file implements the UserRepository interface for saving user level.
// Usage: Used in the data layer to interact with Firestore via UserRemoteDataSource.
// Example:
//   final repo = UserRepositoryImpl(remoteDataSource: ...);
//   await repo.saveUserLevel('user123', Level.beginner);
//   final level = await repo.getUserLevel('user123');

import 'package:dartz/dartz.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/error/firebase_failure.dart';
import 'package:learning_english/core/error/firebase_error_handler.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> saveUserLevel(
    String userId,
    Level level,
  ) async {
    try {
      await remoteDataSource.saveUserLevel(userId, level);
      return const Right(null);
    } catch (exception) {
      // Convert the exception to appropriate FirebaseFailure
      final failure = FirebaseErrorHandler.handleException(
        exception,
        context: 'user_repository_save_level',
      );

      // Return the FirebaseFailure as a generic Failure
      // You can also create a custom failure type if needed
      return Left(ServerFailure(failure.userFriendlyMessage));
    }
  }

  @override
  Future<Either<Failure, Level?>> getUserLevel(String userId) async {
    try {
      final level = await remoteDataSource.getUserLevel(userId);
      return Right(level);
    } catch (exception) {
      // Convert the exception to appropriate FirebaseFailure
      final failure = FirebaseErrorHandler.handleException(
        exception,
        context: 'user_repository_get_level',
      );

      // Return the FirebaseFailure as a generic Failure
      return Left(ServerFailure(failure.userFriendlyMessage));
    }
  }
}
