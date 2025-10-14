// user_profile_service.dart
// Service for managing user profiles with automatic creation on sign-in
// This implementation uses local Hive storage instead of Supabase
//
// Usage Example:
//   final profileService = getIt<UserProfileService>();
//   await profileService.createOrGetProfile(user);
//
// This service automatically creates user profiles when users sign in
// and provides methods to update profile information.

import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_english/features/authentication/domain/entities/user.dart';

/// Service for managing user profiles with automatic creation
/// Handles profile creation, updates, and retrieval using local Hive storage
class UserProfileService {
  static const String _boxName = 'user_profiles';
  Box? _box;

  /// Constructor
  UserProfileService();

  /// Initialize the service and open Hive box
  Future<void> initialize() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(_boxName);
    }
  }

  /// Creates or gets a user profile automatically when user signs in
  /// This method should be called after successful authentication
  /// @param user The authenticated user entity
  /// @returns Future<void> - Profile is created/retrieved automatically
  Future<void> createOrGetProfile(User user) async {
    try {
      await initialize();

      // Check if profile already exists
      final existingProfile = _box?.get(user.id);

      if (existingProfile == null) {
        // Profile doesn't exist, create one with default values
        await _createDefaultProfile(user);
        print('✅ [PROFILE] Created new profile for user: ${user.id}');
      } else {
        print('✅ [PROFILE] Profile already exists for user: ${user.id}');
      }
    } catch (e) {
      print('❌ [PROFILE] Error creating/getting profile: $e');
      // Don't throw here to avoid breaking the authentication flow
      // Profile creation failure shouldn't prevent user from signing in
    }
  }

  /// Creates a default profile for a new user
  /// @param user The authenticated user entity
  /// @returns Future<void>
  Future<void> _createDefaultProfile(User user) async {
    try {
      await initialize();

      final profileData = {
        'user_id': user.id,
        'full_name': user.name,
        'email': user.email,
        'photo_url': user.photoUrl,
        'level': 'beginner', // Default level
        'focus_areas': [], // Default empty focus areas
        'language': 'en', // Default language
        'theme': 'goldTheme', // Default theme
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _box?.put(user.id, profileData);
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  /// Gets the current user's profile
  /// @param userId The user ID to get profile for
  /// @returns Future<Map<String, dynamic>?> The profile data or null if not found
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      await initialize();

      final data = _box?.get(userId);

      if (data != null && data is Map) {
        return Map<String, dynamic>.from(data);
      }

      return null;
    } catch (e) {
      print('❌ [PROFILE] Error getting profile: $e');
      return null;
    }
  }

  /// Updates the user's profile
  /// @param userId The user ID to update profile for
  /// @param updates Map of fields to update
  /// @returns Future<void>
  Future<void> updateProfile(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    try {
      await initialize();

      // Get existing profile
      final existingProfile = _box?.get(userId);

      if (existingProfile != null && existingProfile is Map) {
        // Merge updates with existing profile
        final updatedProfile = Map<String, dynamic>.from(existingProfile);
        updatedProfile.addAll(updates);
        updatedProfile['updated_at'] = DateTime.now().toIso8601String();

        await _box?.put(userId, updatedProfile);
        print('✅ [PROFILE] Updated profile for user: $userId');
      } else {
        // Create new profile if it doesn't exist
        final newProfile = {
          'user_id': userId,
          ...updates,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
        await _box?.put(userId, newProfile);
        print('✅ [PROFILE] Created new profile for user: $userId');
      }
    } catch (e) {
      print('❌ [PROFILE] Error updating profile: $e');
      rethrow;
    }
  }

  /// Updates user's level
  /// @param userId The user ID
  /// @param level The new level (beginner, elementary, intermediate, advanced)
  /// @returns Future<void>
  Future<void> updateLevel(String userId, String level) async {
    await updateProfile(userId, {'level': level});
  }

  /// Updates user's focus areas
  /// @param userId The user ID
  /// @param focusAreas List of focus areas
  /// @returns Future<void>
  Future<void> updateFocusAreas(String userId, List<String> focusAreas) async {
    await updateProfile(userId, {'focus_areas': focusAreas});
  }

  /// Updates user's language preference
  /// @param userId The user ID
  /// @param language The language code (en, fa)
  /// @returns Future<void>
  Future<void> updateLanguage(String userId, String language) async {
    await updateProfile(userId, {'language': language});
  }

  /// Updates user's theme preference
  /// @param userId The user ID
  /// @param theme The theme name
  /// @returns Future<void>
  Future<void> updateTheme(String userId, String theme) async {
    await updateProfile(userId, {'theme': theme});
  }
}
