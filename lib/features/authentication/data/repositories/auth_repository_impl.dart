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
import 'package:learning_english/core/error/firebase_failure.dart';
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
    } on FirebaseAuthFailure catch (e) {
      return Left(ServerFailure(e.userFriendlyMessage));
    } on FirebaseNetworkFailure catch (e) {
      return Left(ServerFailure(e.userFriendlyMessage));
    } on FirebaseRegionalFailure catch (e) {
      return Left(ServerFailure(e.userFriendlyMessage));
    } on FirebaseFirestoreFailure catch (e) {
      return Left(ServerFailure(e.userFriendlyMessage));
    } on FirebaseGenericFailure catch (e) {
      return Left(ServerFailure(e.userFriendlyMessage));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred during sign-in'));
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userModel = await remoteDataSource.getCurrentUser();
      return userModel?.toEntity();
    } on FirebaseAuthFailure catch (e) {
      // Log the error but return null for current user
      print(
        'Firebase Auth Error getting current user: ${e.userFriendlyMessage}',
      );
      return null;
    } on FirebaseNetworkFailure catch (e) {
      print('Network Error getting current user: ${e.userFriendlyMessage}');
      return null;
    } on FirebaseGenericFailure catch (e) {
      print('Generic Error getting current user: ${e.userFriendlyMessage}');
      return null;
    } catch (e) {
      print('Unexpected error getting current user: $e');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await remoteDataSource.signOut();
    } on FirebaseAuthFailure catch (e) {
      // Log the error but don't throw for sign out
      print('Firebase Auth Error during sign out: ${e.userFriendlyMessage}');
    } on FirebaseNetworkFailure catch (e) {
      print('Network Error during sign out: ${e.userFriendlyMessage}');
    } on FirebaseGenericFailure catch (e) {
      print('Generic Error during sign out: ${e.userFriendlyMessage}');
    } catch (e) {
      print('Unexpected error during sign out: $e');
    }
  }
}
