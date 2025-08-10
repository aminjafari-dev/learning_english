// This file defines the UserRemoteDataSource for saving user level to Supabase.
// Usage: Called by the repository to persist the selected level.
// Example:
//   await dataSource.saveUserLevel('user123', Level.beginner);
//   final level = await dataSource.getUserLevel('user123');

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_profile.dart';

/// Remote data source for user level operations using Supabase
/// Handles saving and retrieving user English proficiency levels
class UserRemoteDataSource {
  final SupabaseClient supabase;

  /// Constructor requiring Supabase client instance
  /// @param supabase The Supabase client for database operations
  UserRemoteDataSource(this.supabase);

  /// Saves the user's selected English level to Supabase
  /// Creates or updates the user profile with the selected level
  /// @param userId The unique identifier for the user
  /// @param level The selected English proficiency level
  /// @throws Exception when save operation fails
  Future<void> saveUserLevel(String userId, Level level) async {
    try {
      await supabase
          .from('user_profiles')
          .upsert({
            'user_id': userId,
            'user_level': level.name,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      print('✅ User level saved successfully: ${level.name} for user $userId');
    } catch (exception) {
      print('❌ Error saving user level: $exception');
      rethrow;
    }
  }

  /// Gets the user's selected English level from Supabase
  /// Returns the user's level or null if not found
  /// @param userId The unique identifier for the user
  /// @return The user's level or null if not found
  /// @throws Exception when retrieval operation fails
  Future<Level?> getUserLevel(String userId) async {
    try {
      final response =
          await supabase
              .from('user_profiles')
              .select('user_level')
              .eq('user_id', userId)
              .maybeSingle();

      if (response == null) {
        return null; // User profile doesn't exist
      }

      final levelString = response['user_level'] as String?;
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
