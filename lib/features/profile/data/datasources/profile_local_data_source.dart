/// ProfileLocalDataSource handles local data operations for user profiles.
///
/// This abstract class defines the contract for local profile operations
/// such as caching profile data and storing language preferences using
/// SharedPreferences or other local storage mechanisms.
///
/// Usage Example:
///   class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
///     @override
///     Future<UserProfileModel?> getCachedProfile(String userId) async {
///       // Implementation here
///     }
///   }
import 'package:learning_english/features/profile/data/models/user_profile_model.dart';

/// Abstract local data source for profile operations
abstract class ProfileLocalDataSource {
  /// Retrieves cached user profile data from local storage
  ///
  /// This method fetches the user's profile information from local storage
  /// (e.g., SharedPreferences) and returns it as a UserProfileModel.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - UserProfileModel?: The cached profile data, or null if not found
  ///
  /// Throws:
  ///   - CacheException: If the local operation fails
  Future<UserProfileModel?> getCachedProfile(String userId);

  /// Caches user profile data in local storage
  ///
  /// This method stores the user's profile information in local storage
  /// for offline access and faster loading.
  ///
  /// Parameters:
  ///   - userProfile: The profile data to cache
  ///
  /// Returns:
  ///   - bool: True if caching was successful
  ///
  /// Throws:
  ///   - CacheException: If the local operation fails
  Future<bool> cacheProfile(UserProfileModel userProfile);

  /// Retrieves the user's preferred app language from local storage
  ///
  /// This method fetches the language preference from local storage
  /// and returns it as a language code string.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - String: The language code (e.g., 'en', 'fa'), defaults to 'en'
  ///
  /// Throws:
  ///   - CacheException: If the local operation fails
  Future<String> getAppLanguage(String userId);

  /// Stores the user's preferred app language in local storage
  ///
  /// This method saves the language preference to local storage
  /// for persistence across app sessions.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///   - language: The language code to store (e.g., 'en', 'fa')
  ///
  /// Returns:
  ///   - bool: True if storage was successful
  ///
  /// Throws:
  ///   - CacheException: If the local operation fails
  Future<bool> setAppLanguage(String userId, String language);

  /// Clears cached profile data for a user
  ///
  /// This method removes the cached profile data from local storage,
  /// typically used when logging out or when cache becomes stale.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - bool: True if clearing was successful
  ///
  /// Throws:
  ///   - CacheException: If the local operation fails
  Future<bool> clearCachedProfile(String userId);

  /// Checks if profile data is cached for a user
  ///
  /// This method checks whether profile data exists in local storage
  /// for the given user.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - bool: True if profile data is cached
  ///
  /// Throws:
  ///   - CacheException: If the local operation fails
  Future<bool> isProfileCached(String userId);
}
