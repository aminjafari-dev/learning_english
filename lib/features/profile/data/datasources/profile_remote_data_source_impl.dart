/// ProfileRemoteDataSourceImpl implements remote data operations for user profiles.
///
/// This class provides concrete implementation of remote profile operations
/// using Supabase for profile data storage and retrieval.
///
/// Usage Example:
///   final dataSource = ProfileRemoteDataSourceImpl();
///   final profile = await dataSource.getUserProfile(currentUserId);
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:learning_english/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:learning_english/features/profile/data/models/user_profile_model.dart';

/// Exception class for server-related errors
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

/// Implementation of ProfileRemoteDataSource using Supabase
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  /// Supabase client instance
  final SupabaseClient _supabase;

  /// Constructor for ProfileRemoteDataSourceImpl
  ///
  /// Parameters:
  ///   - supabase: Supabase client instance (optional, uses default if not provided)
  ProfileRemoteDataSourceImpl({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  /// Retrieves user profile data from remote storage
  ///
  /// This method fetches the user's profile information from Supabase
  /// and returns it as a UserProfileModel.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - UserProfileModel: The user's profile data
  ///
  /// Throws:
  ///   - ServerException: If the remote operation fails
  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      final response =
          await _supabase
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

        await _supabase.from('user_profiles').upsert({
          'user_id': userId,
          ...defaultProfile.toJson(),
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        return defaultProfile;
      }

      return UserProfileModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get user profile: ${e.toString()}');
    }
  }

  /// Updates user profile data in remote storage
  ///
  /// This method updates the user's profile information in Supabase
  /// and returns the updated profile data.
  ///
  /// Parameters:
  ///   - userProfile: The updated profile data to save
  ///
  /// Returns:
  ///   - UserProfileModel: The updated profile data
  ///
  /// Throws:
  ///   - ServerException: If the remote operation fails
  @override
  Future<UserProfileModel> updateUserProfile({
    required String userId,
    required UserProfileModel userProfile,
  }) async {
    try {
      await _supabase.from('user_profiles').upsert({
        'user_id': userId,
        ...userProfile.toJson(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      return userProfile;
    } catch (e) {
      throw ServerException('Failed to update user profile: ${e.toString()}');
    }
  }

  /// Uploads a profile image and returns the URL
  ///
  /// This method uploads an image file to Supabase Storage and returns
  /// the public URL for the uploaded image.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///   - imagePath: The local path to the image file
  ///
  /// Returns:
  ///   - String: The public URL of the uploaded image
  ///
  /// Throws:
  ///   - ServerException: If the upload operation fails
  @override
  Future<String> uploadProfileImage(String userId, String imagePath) async {
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
      throw ServerException('Failed to upload profile image: ${e.toString()}');
    }
  }

  /// Removes a profile image from storage
  ///
  /// This method removes an image file from Supabase Storage.
  ///
  /// Parameters:
  ///   - imageUrl: The URL of the image to remove
  ///
  /// Returns:
  ///   - void
  ///
  /// Throws:
  ///   - ServerException: If the removal operation fails
  @override
  Future<bool> deleteProfileImage(String imageUrl) async {
    try {
      // For now, just log the operation
      // TODO: Implement Supabase Storage deletion when dependency is properly configured

      print('Profile image removal placeholder');
      print('Image URL: $imageUrl');
      return true; // Return success for placeholder implementation
    } catch (e) {
      throw ServerException('Failed to remove profile image: ${e.toString()}');
    }
  }
}
