/// UserRepositoryImpl implements the core UserRepository interface.
///
/// This implementation uses the existing authentication data source
/// to provide user ID operations across the application.
///
/// Usage Example:
///   final repository = UserRepositoryImpl(userLocalDataSource);
///   final userId = await repository.getUserId();
import 'package:learning_english/core/repositories/user_repository.dart';
import 'package:learning_english/features/authentication/data/datasources/user_local_data_source.dart';

/// Implementation of the core UserRepository
class UserRepositoryImpl implements UserRepository {
  /// The local data source for user operations
  final UserLocalDataSource _userLocalDataSource;

  /// Constructor for UserRepositoryImpl
  ///
  /// Parameters:
  ///   - userLocalDataSource: The local data source for user operations
  const UserRepositoryImpl(this._userLocalDataSource);

  /// Retrieves the current user ID from local storage
  ///
  /// Returns:
  ///   - String?: The current user ID, or null if not found
  @override
  Future<String?> getUserId() async {
    return await _userLocalDataSource.getUserId();
  }

  /// Saves the user ID to local storage
  ///
  /// Parameters:
  ///   - userId: The user ID to save
  @override
  Future<void> saveUserId(String userId) async {
    await _userLocalDataSource.saveUserId(userId);
  }

  /// Removes the user ID from local storage (e.g., on logout)
  @override
  Future<void> removeUserId() async {
    await _userLocalDataSource.removeUserId();
  }
}
