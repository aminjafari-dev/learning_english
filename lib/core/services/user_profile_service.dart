// user_profile_service.dart
// Service for managing user profiles with automatic creation on sign-in
//
// Usage Example:
//   final profileService = getIt<UserProfileService>();
//   await profileService.createOrGetProfile(userId, userData);
//
// This service automatically creates user profiles when users sign in
// and provides methods to update profile information.

import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:learning_english/features/authentication/domain/entities/user.dart';

/// Service for managing user profiles with automatic creation
/// Handles profile creation, updates, and retrieval
class UserProfileService {
  final SupabaseClient _supabaseClient;

  /// Constructor that injects Supabase client
  /// @param supabaseClient The Supabase client instance for database operations
  UserProfileService({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  /// Creates or gets a user profile automatically when user signs in
  /// This method should be called after successful authentication
  /// @param user The authenticated user entity
  /// @returns Future<void> - Profile is created/retrieved automatically
  Future<void> createOrGetProfile(User user) async {
    try {
      // Check if profile already exists
      final response =
          await _supabaseClient
              .from('user_profiles')
              .select('*')
              .eq('user_id', user.id)
              .maybeSingle();

      if (response == null) {
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
      await _supabaseClient.from('user_profiles').insert({
        'user_id': user.id,
        'full_name': user.name,
        'email': user.email,
        'level': 'beginner', // Default level
        'focus_areas': [], // Default empty focus areas
        'language': 'en', // Default language
        'theme': 'goldTheme', // Default theme
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  /// Gets the current user's profile
  /// @param userId The user ID to get profile for
  /// @returns Future<Map<String, dynamic>?> The profile data or null if not found
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response =
          await _supabaseClient
              .from('user_profiles')
              .select('*')
              .eq('user_id', userId)
              .maybeSingle();

      return response;
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
      await _supabaseClient
          .from('user_profiles')
          .update({...updates, 'updated_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId);

      print('✅ [PROFILE] Updated profile for user: $userId');
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
