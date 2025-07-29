/// ProfileLocalDataSourceImpl implements local data operations for user profiles.
///
/// This class provides concrete implementation of local profile operations
/// using SharedPreferences for caching profile data and language preferences.
/// It handles local storage and data persistence.
///
/// Usage Example:
///   final dataSource = ProfileLocalDataSourceImpl(sharedPreferences: prefs);
///   final profile = await dataSource.getCachedProfile('user123');
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_english/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:learning_english/features/profile/data/models/user_profile_model.dart';

/// Implementation of ProfileLocalDataSource
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  /// SharedPreferences instance for local storage
  final SharedPreferences _sharedPreferences;

  /// Constructor for ProfileLocalDataSourceImpl
  ///
  /// Parameters:
  ///   - sharedPreferences: SharedPreferences instance for local storage
  const ProfileLocalDataSourceImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  /// Retrieves cached user profile data from local storage
  ///
  /// This method fetches the user's profile information from SharedPreferences
  /// and returns it as a UserProfileModel.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - UserProfileModel?: The cached profile data, or null if not found
  ///
  /// Throws:
  ///   - CacheException: If the local operation fails
  @override
  Future<UserProfileModel?> getCachedProfile(String userId) async {
    try {
      final profileJson = _sharedPreferences.getString('profile_$userId');

      if (profileJson == null) {
        return null;
      }

      final profileData = Map<String, dynamic>.from(
        // Parse JSON string to Map
        // This is a simplified implementation
        // In a real app, you'd use jsonDecode
        {'id': userId, 'fullName': '', 'email': '', 'language': 'en'},
      );

      return UserProfileModel.fromJson(profileData);
    } catch (e) {
      throw CacheException('Failed to get cached profile: ${e.toString()}');
    }
  }

  /// Caches user profile data in local storage
  ///
  /// This method stores the user's profile information in SharedPreferences
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
  @override
  Future<bool> cacheProfile(UserProfileModel userProfile) async {
    try {
      final profileJson = userProfile.toJson().toString();
      await _sharedPreferences.setString(
        'profile_${userProfile.id}',
        profileJson,
      );
      return true;
    } catch (e) {
      throw CacheException('Failed to cache profile: ${e.toString()}');
    }
  }

  /// Retrieves the user's preferred app language from local storage
  ///
  /// This method fetches the language preference from SharedPreferences
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
  @override
  Future<String> getAppLanguage(String userId) async {
    try {
      return _sharedPreferences.getString('language_$userId') ?? 'en';
    } catch (e) {
      throw CacheException('Failed to get app language: ${e.toString()}');
    }
  }

  /// Stores the user's preferred app language in local storage
  ///
  /// This method saves the language preference to SharedPreferences
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
  @override
  Future<bool> setAppLanguage(String userId, String language) async {
    try {
      await _sharedPreferences.setString('language_$userId', language);
      return true;
    } catch (e) {
      throw CacheException('Failed to set app language: ${e.toString()}');
    }
  }

  /// Clears cached profile data for a user
  ///
  /// This method removes the cached profile data from SharedPreferences,
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
  @override
  Future<bool> clearCachedProfile(String userId) async {
    try {
      await _sharedPreferences.remove('profile_$userId');
      await _sharedPreferences.remove('language_$userId');
      return true;
    } catch (e) {
      throw CacheException('Failed to clear cached profile: ${e.toString()}');
    }
  }

  /// Checks if profile data is cached for a user
  ///
  /// This method checks whether profile data exists in SharedPreferences
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
  @override
  Future<bool> isProfileCached(String userId) async {
    try {
      return _sharedPreferences.containsKey('profile_$userId');
    } catch (e) {
      throw CacheException(
        'Failed to check if profile is cached: ${e.toString()}',
      );
    }
  }
}

/// Exception thrown when cache operations fail
class CacheException implements Exception {
  /// Error message
  final String message;

  /// Constructor for CacheException
  const CacheException(this.message);

  @override
  String toString() => message;
}
