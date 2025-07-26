// remove_user_id_usecase.dart
// Use case for removing userId from local storage.
//
// Usage Example:
//   final result = await removeUserIdUseCase(NoParams());
//   result.fold((failure) => ..., (_) => ...);

import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

/// Use case for removing user ID from local storage
/// This is typically used during logout to clear user authentication data
class RemoveUserIdUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  RemoveUserIdUseCase(this.repository);

  /// Removes the userId from local storage
  /// Returns void on success or Failure on error
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    try {
      await repository.removeUserId();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
