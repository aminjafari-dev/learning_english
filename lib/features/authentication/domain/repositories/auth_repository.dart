// auth_repository.dart
// Abstract repository for authentication operations.
//
// Usage Example:
//   final result = await repository.signInWithGoogle();
//   result.fold((failure) => ..., (user) => ...);
//
// This interface is implemented in the data layer.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Signs in the user with Google. Returns Either Failure or User.
  Future<Either<Failure, User>> signInWithGoogle();

  /// Returns the currently signed-in user, or null if not signed in.
  Future<User?> getCurrentUser();

  /// Signs out the current user.
  Future<void> signOut();

  /// Saves the userId locally (for global access)
  Future<void> saveUserId(String userId);

  /// Retrieves the userId from local storage
  Future<String?> getUserId();

  /// Removes the userId from local storage (e.g., on logout)
  Future<void> removeUserId();
}
