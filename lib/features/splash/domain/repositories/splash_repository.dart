// splash_repository.dart
// Repository interface for splash-related operations.
//
// Usage Example:
//   final result = await splashRepository.checkAuthenticationStatus();
//   result.fold((failure) => ..., (splashEntity) => ...);

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import '../entities/splash_entity.dart';

/// Repository interface for splash-related operations
abstract class SplashRepository {
  /// Checks the authentication status of the user
  /// Returns a SplashEntity indicating whether the user is authenticated
  Future<Either<Failure, SplashEntity>> checkAuthenticationStatus();
}
