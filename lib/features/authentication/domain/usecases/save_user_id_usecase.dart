// save_user_id_usecase.dart
// Use case for saving userId locally.
//
// Usage Example:
//   final result = await saveUserIdUseCase('abc123');
//   result.fold((failure) => ..., (_) => ...);

import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class SaveUserIdUseCase implements UseCase<void, String> {
  final AuthRepository repository;
  SaveUserIdUseCase(this.repository);

  /// Saves the userId locally
  @override
  Future<Either<Failure, void>> call(String userId) async {
    try {
      await repository.saveUserId(userId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
