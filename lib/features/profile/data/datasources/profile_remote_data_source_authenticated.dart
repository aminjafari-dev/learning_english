// profile_remote_data_source_authenticated.dart
// Example of how to use authentication middleware with existing data sources.
//
// Usage Example:
//   final profileDataSource = getIt<ProfileRemoteDataSourceAuthenticated>();
//   final profile = await profileDataSource.getUserProfile();
//   final updatedProfile = await profileDataSource.updateUserProfile(userProfile);
//
// This example shows how to integrate authentication middleware with existing
// data sources to ensure all operations are properly authenticated.

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:learning_english/core/services/auth_middleware.dart';
import 'package:learning_english/core/services/auth_service.dart';
import 'package:learning_english/features/profile/data/models/user_profile_model.dart';
import 'package:learning_english/core/error/failure.dart';

/// Example of authenticated profile remote data source
/// Shows how to integrate authentication middleware with existing data sources
abstract class ProfileRemoteDataSourceAuthenticated {
  /// Gets the current user's profile with authentication validation
  /// @return UserProfileModel containing the user's profile data
  /// This method automatically validates authentication and gets the current user's ID
  Future<UserProfileModel> getUserProfile();

  /// Updates the current user's profile with authentication validation
  /// @param userProfile The updated profile data to save
  /// @return UserProfileModel containing the updated profile data
  /// This method ensures only the authenticated user can update their own profile
  Future<UserProfileModel> updateUserProfile(UserProfileModel userProfile);

  /// Uploads a profile image for the current user with authentication validation
  /// @param imagePath The local path to the image file
  /// @return String containing the URL of the uploaded image
  /// This method ensures only the authenticated user can upload their own image
  Future<String> uploadProfileImage(String imagePath);
}

/// Implementation of authenticated profile remote data source
/// Uses authentication middleware to protect all database operations
class ProfileRemoteDataSourceAuthenticatedImpl
    implements ProfileRemoteDataSourceAuthenticated {
  final SupabaseClient _supabaseClient;

  /// Constructor that injects Supabase client
  /// @param supabaseClient The Supabase client for database operations
  ProfileRemoteDataSourceAuthenticatedImpl({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  @override
  Future<UserProfileModel> getUserProfile() async {
    // Use authentication middleware to ensure user is authenticated
    return await AuthMiddleware.withUserContext((userId) async {
      try {
        final response =
            await _supabaseClient
                .from('user_profiles')
                .select()
                .eq('user_id', userId)
                .maybeSingle();

        if (response == null) {
          // Create default profile if user doesn't exist
          final defaultProfile = UserProfileModel(
            fullName: '',
            email: '',
            language: 'en',
          );

          await _supabaseClient.from('user_profiles').upsert({
            'user_id': userId,
            ...defaultProfile.toJson(),
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          });

          return defaultProfile;
        }

        return UserProfileModel.fromJson(response);
      } catch (e) {
        throw ServerFailure('Failed to get user profile: ${e.toString()}');
      }
    });
  }

  @override
  Future<UserProfileModel> updateUserProfile(
    UserProfileModel userProfile,
  ) async {
    // Use authentication middleware to ensure user is authenticated
    return await AuthMiddleware.withUserContext((userId) async {
      try {
        await _supabaseClient.from('user_profiles').upsert({
          'user_id': userId,
          ...userProfile.toJson(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        return userProfile;
      } catch (e) {
        if (e is UnauthorizedException) {
          rethrow;
        }
        throw ServerFailure('Failed to update user profile: ${e.toString()}');
      }
    });
  }

  @override
  Future<String> uploadProfileImage(String imagePath) async {
    // Use authentication middleware to ensure user is authenticated
    return await AuthMiddleware.withUserContext((userId) async {
      try {
        // For now, return a placeholder URL
        // TODO: Implement Supabase Storage upload when dependency is properly configured
        final placeholderUrl =
            'https://via.placeholder.com/150x150.png?text=Profile';

        print('Profile image upload placeholder for user $userId');
        print('Image path: $imagePath');
        print('Placeholder URL: $placeholderUrl');

        return placeholderUrl;
      } catch (e) {
        throw ServerFailure('Failed to upload profile image: ${e.toString()}');
      }
    });
  }

  /// Example of using authentication middleware with record ownership validation
  /// @param profileId The ID of the profile to delete
  /// @return true if deletion was successful
  /// This method shows how to validate record ownership before operations
  Future<bool> deleteUserProfile(String profileId) async {
    return await AuthMiddleware.withAuth(() async {
      try {
        // First, get the profile to validate ownership
        final response =
            await _supabaseClient
                .from('user_profiles')
                .select('user_id')
                .eq('id', profileId)
                .single();

        final recordUserId = response['user_id'] as String;

        // Validate record ownership using middleware
        if (!AuthMiddleware.validateRecordOwnership(recordUserId)) {
          throw UnauthorizedException('Cannot delete another user\'s profile');
        }

        // Delete the profile
        await _supabaseClient
            .from('user_profiles')
            .delete()
            .eq('id', profileId);

        return true;
      } catch (e) {
        if (e is UnauthorizedException) {
          rethrow;
        }
        throw ServerFailure('Failed to delete user profile: ${e.toString()}');
      }
    });
  }

  /// Example of using authentication middleware with conditional operations
  /// @param operation The operation to perform
  /// @return The result of the operation or null if not authenticated
  /// This method shows how to handle operations that can work with or without authentication
  Future<UserProfileModel?> getUserProfileIfAuthenticated() async {
    return await AuthMiddleware.withAuthOrDefault(
      () => getUserProfile(),
      null, // Return null if not authenticated
    );
  }
}
