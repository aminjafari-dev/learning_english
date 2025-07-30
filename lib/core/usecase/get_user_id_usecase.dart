/// GetUserIdUseCase is a core use case for retrieving the current user ID.
///
/// This use case is part of the core layer and can be used across multiple features
/// to get the current authenticated user's ID from local storage.
///
/// Usage Example:
///   final result = await getUserIdUseCase(NoParams());
///   result.fold(
///     (failure) => print('Error: ${failure.message}'),
///     (userId) => print('User ID: $userId'),
///   );
import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/core/repositories/user_repository.dart';

/// Use case for retrieving the current user ID
class GetUserIdUseCase implements UseCase<String?, NoParams> {
  /// The user repository dependency
  final UserRepository _userRepository;

  /// Constructor for GetUserIdUseCase
  ///
  /// Parameters:
  ///   - userRepository: The repository to use for user operations
  const GetUserIdUseCase(this._userRepository);

  /// Executes the use case to get the current user ID
  ///
  /// This method calls the repository to retrieve the current user ID
  /// from local storage and returns the result wrapped in Either<Failure, String?>
  ///
  /// Parameters:
  ///   - params: NoParams (no parameters needed)
  ///
  /// Returns:
  ///   - Either<Failure, String?>: Success with user ID or failure
  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    try {
      final userId = await _userRepository.getUserId();
      return Right(userId);
    } catch (e) {
      return Left(CacheFailure('Failed to get user ID: ${e.toString()}'));
    }
  }
}
