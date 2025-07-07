// sign_in_with_google_usecase.dart
// Use case for signing in with Google.
//
// Usage Example:
//   final result = await signInWithGoogleUseCase(NoParams());
//   result.fold((failure) => ..., (user) => ...);
//
// This use case is injected into the AuthenticationBloc.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase implements UseCase<User, NoParams> {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return repository.signInWithGoogle();
  }
}
