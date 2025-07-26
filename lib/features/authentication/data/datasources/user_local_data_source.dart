// user_local_data_source.dart
// Local data source for saving and retrieving userId using shared_preferences.
//
// Usage Example:
//   final dataSource = UserLocalDataSourceImpl();
//   await dataSource.saveUserId('abc123');
//   final userId = await dataSource.getUserId();
//
// This class is used in the data layer only.

import 'package:shared_preferences/shared_preferences.dart';

/// Abstract class for user local data source
abstract class UserLocalDataSource {
  /// Saves the userId locally
  Future<void> saveUserId(String userId);

  /// Retrieves the userId, or null if not found
  Future<String?> getUserId();

  /// Removes the userId (e.g., on logout)
  Future<void> removeUserId();
}

/// Implementation using shared_preferences
class UserLocalDataSourceImpl implements UserLocalDataSource {
  static const String _userIdKey = 'user_id';
  
  final SharedPreferences _prefs;
  
  /// Constructor that accepts SharedPreferences instance
  /// This allows for dependency injection and better testability
  UserLocalDataSourceImpl(this._prefs);

  /// Saves the userId to shared preferences
  @override
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(_userIdKey, userId);
  }

  /// Retrieves the userId from shared preferences
  @override
  Future<String?> getUserId() async {
    return _prefs.getString(_userIdKey);
  }

  /// Removes the userId from shared preferences
  @override
  Future<void> removeUserId() async {
    await _prefs.remove(_userIdKey);
  }
}
