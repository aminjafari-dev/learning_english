// get_user_id_usecase.dart
// Use case for retrieving userId locally.
//
// Usage Example:
//   final result = await getUserIdUseCase(NoParams());
//   result.fold((failure) => ..., (userId) => ...);

import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';

class GetUserIdUseCase implements UseCase<String?, NoParams> {
  final AuthRepository repository;
  GetUserIdUseCase(this.repository);

  /// Retrieves the userId from local storage
  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    try {
      final userId = await repository.getUserId();
      return Right(userId);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
