// splash_repository_impl.dart
// Implementation of the splash repository.
//
// Usage Example:
//   final result = await splashRepository.checkAuthenticationStatus();
//   result.fold((failure) => ..., (splashEntity) => ...);

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import '../../domain/entities/splash_entity.dart';
import '../../domain/repositories/splash_repository.dart';
import '../datasources/splash_local_data_source.dart';

/// Implementation of SplashRepository
class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource localDataSource;

  /// Creates a new instance of SplashRepositoryImpl
  SplashRepositoryImpl({required this.localDataSource});

  /// Checks the authentication status by retrieving the stored user ID
  @override
  Future<Either<Failure, SplashEntity>> checkAuthenticationStatus() async {
    try {
      final userId = await localDataSource.getStoredUserId();

      if (userId != null && userId.isNotEmpty) {
        // User is authenticated
        return Right(SplashEntity.authenticated(userId: userId));
      } else {
        // User is not authenticated
        return Right(const SplashEntity.unauthenticated());
      }
    } catch (e) {
      // Return error state if there's an exception
      return Right(SplashEntity.error(errorMessage: e.toString()));
    }
  }
}
