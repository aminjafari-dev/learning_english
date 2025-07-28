// check_authentication_status_usecase.dart
// Use case for checking user authentication status.
//
// Usage Example:
//   final result = await checkAuthenticationStatusUseCase(NoParams());
//   result.fold((failure) => ..., (splashEntity) => ...);

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../entities/splash_entity.dart';
import '../repositories/splash_repository.dart';

/// Use case for checking user authentication status
class CheckAuthenticationStatusUseCase
    implements UseCase<SplashEntity, NoParams> {
  final SplashRepository repository;

  /// Creates a new instance of CheckAuthenticationStatusUseCase
  CheckAuthenticationStatusUseCase(this.repository);

  /// Checks the authentication status of the user
  /// Returns a SplashEntity indicating whether the user is authenticated
  @override
  Future<Either<Failure, SplashEntity>> call(NoParams params) async {
    try {
      final result = await repository.checkAuthenticationStatus();
      return result;
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
