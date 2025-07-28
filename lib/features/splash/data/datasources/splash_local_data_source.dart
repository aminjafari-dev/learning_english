// splash_local_data_source.dart
// Local data source for splash-related operations.
//
// Usage Example:
//   final userId = await splashLocalDataSource.getStoredUserId();
//   if (userId != null) {
//     // User is authenticated
//   } else {
//     // User is not authenticated
//   }

import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for splash-related operations
abstract class SplashLocalDataSource {
  /// Gets the stored user ID from local storage
  Future<String?> getStoredUserId();
}

/// Implementation of SplashLocalDataSource using SharedPreferences
class SplashLocalDataSourceImpl implements SplashLocalDataSource {
  static const String _userIdKey = 'user_id';

  /// Gets the stored user ID from SharedPreferences
  @override
  Future<String?> getStoredUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userIdKey);
    } catch (e) {
      // If there's an error reading from SharedPreferences, return null
      // This indicates the user is not authenticated
      return null;
    }
  }
}
