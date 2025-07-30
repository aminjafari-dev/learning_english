/// UserRepository is a core repository interface for user-related operations.
///
/// This repository is part of the core layer and provides a common interface
/// for user operations that can be used across multiple features.
///
/// Usage Example:
///   final userId = await userRepository.getUserId();
///   await userRepository.saveUserId('user123');
///   await userRepository.removeUserId();
abstract class UserRepository {
  /// Retrieves the current user ID from local storage
  ///
  /// Returns:
  ///   - String?: The current user ID, or null if not found
  Future<String?> getUserId();

  /// Saves the user ID to local storage
  ///
  /// Parameters:
  ///   - userId: The user ID to save
  Future<void> saveUserId(String userId);

  /// Removes the user ID from local storage (e.g., on logout)
  Future<void> removeUserId();
}
