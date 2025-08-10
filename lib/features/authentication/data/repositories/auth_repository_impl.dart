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

/// Authentication repository implementation using Google Sign-In
/// Handles user authentication operations with proper error handling
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  /// Inject both remote and local data sources
  /// @param remoteDataSource For Google Sign-In operations
  /// @param localDataSource For local user data persistence
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
      return Left(ServerFailure('An unexpected error occurred during sign-in'));
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return userModel?.toEntity();
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } catch (e) {
      print('Error during sign out: $e');
    }
  }
}
