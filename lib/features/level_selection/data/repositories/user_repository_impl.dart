// This file implements the UserRepository interface for saving user level.
// Usage: Used in the data layer to interact with Firestore via UserRemoteDataSource.
// Example:
//   final repo = UserRepositoryImpl(remoteDataSource: ...);
//   await repo.saveUserLevel('user123', Level.beginner);

import 'package:dartz/dartz.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import 'package:learning_english/core/error/failure.dart';

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
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
