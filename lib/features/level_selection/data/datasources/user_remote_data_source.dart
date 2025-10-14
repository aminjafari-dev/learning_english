// user_remote_data_source.dart
// This file defines the UserRemoteDataSource for saving user level to local Hive storage.
// No longer uses Supabase - all data is stored locally.
//
// Usage: Called by the repository to persist the selected level.
// Example:
//   await dataSource.saveUserLevel('user123', Level.beginner);
//   final level = await dataSource.getUserLevel('user123');

import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/user_profile.dart';

/// Remote data source for user level operations using Hive local storage
/// Handles saving and retrieving user English proficiency levels
class UserRemoteDataSource {
  static const String _boxName = 'user_profiles';
  static const String _levelKey = 'user_level';

  Box? _box;

  /// Constructor
  UserRemoteDataSource();

  /// Initialize the data source and open Hive box
  Future<void> initialize() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(_boxName);
    }
  }

  /// Saves the user's selected English level to local storage
  /// Creates or updates the user profile with the selected level
  /// @param userId The unique identifier for the user
  /// @param level The selected English proficiency level
  /// @throws Exception when save operation fails
  Future<void> saveUserLevel(String userId, Level level) async {
    try {
      await initialize();

      // Store user level in Hive
      final key = '${userId}_$_levelKey';
      await _box?.put(key, {
        'user_id': userId,
        'user_level': level.name,
        'updated_at': DateTime.now().toIso8601String(),
      });

      print('✅ User level saved successfully: ${level.name} for user $userId');
    } catch (exception) {
      print('❌ Error saving user level: $exception');
      rethrow;
    }
  }

  /// Gets the user's selected English level from local storage
  /// Returns the user's level or null if not found
  /// @param userId The unique identifier for the user
  /// @return The user's level or null if not found
  /// @throws Exception when retrieval operation fails
  Future<Level?> getUserLevel(String userId) async {
    try {
      await initialize();

      final key = '${userId}_$_levelKey';
      final data = _box?.get(key);

      if (data == null || data is! Map) {
        return null; // User profile doesn't exist
      }

      final levelString = data['user_level'] as String?;
      if (levelString == null) {
        return null; // No level field in profile
      }

      // Convert string to Level enum
      switch (levelString.toLowerCase()) {
        case 'beginner':
          return Level.beginner;
        case 'elementary':
          return Level.elementary;
        case 'intermediate':
          return Level.intermediate;
        case 'advanced':
          return Level.advanced;
        default:
          return null; // Invalid level string
      }
    } catch (exception) {
      print('❌ Error getting user level: $exception');
      rethrow;
    }
  }
}
