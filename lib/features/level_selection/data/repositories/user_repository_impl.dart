// This file implements the UserRepository interface for saving user level.
// Usage: Used in the data layer to interact with Supabase via UserRemoteDataSource.
// Example:
//   final repo = UserRepositoryImpl(remoteDataSource: ...);
//   await repo.saveUserLevel('user123', Level.beginner);
//   final level = await repo.getUserLevel('user123');

import 'package:dartz/dartz.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import 'package:learning_english/core/error/failure.dart';

/// Repository implementation for user level operations using Supabase
/// Implements the UserRepository interface and handles error conversion
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  /// Constructor requiring the remote data source
  /// @param remoteDataSource The data source for remote operations
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
      // Convert any exception to a ServerFailure with user-friendly message
      return Left(
        ServerFailure(
          'Failed to save user level. Please check your internet connection and try again.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Level?>> getUserLevel(String userId) async {
    try {
      final level = await remoteDataSource.getUserLevel(userId);
      return Right(level);
    } catch (exception) {
      // Convert any exception to a ServerFailure with user-friendly message
      return Left(
        ServerFailure(
          'Failed to retrieve user level. Please check your internet connection and try again.',
        ),
      );
    }
  }
}
