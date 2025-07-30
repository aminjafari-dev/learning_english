// auth_repository_impl.dart
// Implementation of AuthRepository using AuthRemoteDataSource.
//
// Usage Example:
//   final result = await repository.signInWithGoogle();
//   result.fold((failure) => ..., (user) => ...);
//
// Handles error mapping and data conversion.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/user_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  /// Inject both remote and local data sources
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final userModel = await remoteDataSource.signInWithGoogle();
      return Right(userModel.toEntity());
    } catch (e) {
      // Map error to Failure (customize as needed)
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final userModel = await remoteDataSource.getCurrentUser();
    return userModel?.toEntity();
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }


}
