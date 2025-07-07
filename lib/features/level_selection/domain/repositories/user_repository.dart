// This file defines the UserRepository interface for saving user level.
// Usage: Implemented in the data layer to interact with Firestore.
// Example:
//   await repository.saveUserLevel('user123', Level.beginner);

import 'package:dartz/dartz.dart';
import '../entities/user_profile.dart';
import 'package:learning_english/core/error/failure.dart';

abstract class UserRepository {
  /// Saves the user's selected English level to Firestore
  Future<Either<Failure, void>> saveUserLevel(String userId, Level level);
}
