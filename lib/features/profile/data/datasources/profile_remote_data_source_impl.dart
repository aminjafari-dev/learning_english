/// ProfileRemoteDataSourceImpl implements remote data operations for user profiles.
/// This implementation uses local Hive storage instead of Supabase.
///
/// This class provides concrete implementation of profile operations
/// using Hive for profile data storage and retrieval.
///
/// Usage Example:
///   final dataSource = ProfileRemoteDataSourceImpl();
///   final profile = await dataSource.getUserProfile(currentUserId);

import 'package:hive_flutter/hive_flutter.dart';
import 'package:learning_english/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:learning_english/features/profile/data/models/user_profile_model.dart';

/// Exception class for server-related errors
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

/// Implementation of ProfileRemoteDataSource using Hive local storage
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  static const String _boxName = 'user_profiles';
  Box? _box;

  /// Constructor for ProfileRemoteDataSourceImpl
  ProfileRemoteDataSourceImpl();

  /// Initialize the data source and open Hive box
  Future<void> initialize() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(_boxName);
    }
  }

  /// Retrieves user profile data from local storage
  ///
  /// This method fetches the user's profile information from Hive
  /// and returns it as a UserProfileModel.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - UserProfileModel: The user's profile data
  ///
  /// Throws:
  ///   - ServerException: If the operation fails
  @override
  Future<UserProfileModel> getUserProfile(String userId) async {
    try {
      await initialize();

      final data = _box?.get(userId);

      if (data == null || data is! Map) {
        // Create default profile if user doesn't exist
        final defaultProfile = UserProfileModel(
          fullName: '',
          email: '',
          language: 'en',
        );

        await _box?.put(userId, {
          'user_id': userId,
          ...defaultProfile.toJson(),
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        return defaultProfile;
      }

      return UserProfileModel.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      throw ServerException('Failed to get user profile: ${e.toString()}');
    }
  }

  /// Updates user profile data in local storage
  ///
  /// This method updates the user's profile information in Hive
  /// and returns the updated profile data.
  ///
  /// Parameters:
  ///   - userId: The user ID
  ///   - userProfile: The updated profile data to save
  ///
  /// Returns:
  ///   - UserProfileModel: The updated profile data
  ///
  /// Throws:
  ///   - ServerException: If the operation fails
  @override
  Future<UserProfileModel> updateUserProfile({
    required String userId,
    required UserProfileModel userProfile,
  }) async {
    try {
      await initialize();

      await _box?.put(userId, {
        'user_id': userId,
        ...userProfile.toJson(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      return userProfile;
    } catch (e) {
      throw ServerException('Failed to update user profile: ${e.toString()}');
    }
  }

  /// Uploads a profile image and returns a placeholder URL
  ///
  /// Since we're using local storage, this method returns a placeholder URL.
  /// In a production app, you might want to save the image locally and return a local path.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///   - imagePath: The local path to the image file
  ///
  /// Returns:
  ///   - String: The placeholder URL (or local path)
  ///
  /// Throws:
  ///   - ServerException: If the operation fails
  @override
  Future<String> uploadProfileImage(String userId, String imagePath) async {
    try {
      // For local storage, we can save the image path
      // In a real app, you might want to copy the image to app's documents directory

      await initialize();

      final existingProfile = _box?.get(userId);
      if (existingProfile != null && existingProfile is Map) {
        final updatedProfile = Map<String, dynamic>.from(existingProfile);
        updatedProfile['photo_url'] = imagePath;
        updatedProfile['updated_at'] = DateTime.now().toIso8601String();
        await _box?.put(userId, updatedProfile);
      }

      print('Profile image saved locally for user $userId');
      print('Image path: $imagePath');

      return imagePath;
    } catch (e) {
      throw ServerException('Failed to save profile image: ${e.toString()}');
    }
  }

  /// Removes a profile image from storage
  ///
  /// This method removes the image reference from the user's profile.
  ///
  /// Parameters:
  ///   - imageUrl: The URL/path of the image to remove
  ///
  /// Returns:
  ///   - bool: True if successful
  ///
  /// Throws:
  ///   - ServerException: If the operation fails
  @override
  Future<bool> deleteProfileImage(String imageUrl) async {
    try {
      await initialize();

      // Find the user profile that has this image URL
      // For simplicity, we'll just clear photo_url from all profiles that match
      final allKeys = _box?.keys.toList() ?? [];

      for (final key in allKeys) {
        final profile = _box?.get(key);
        if (profile is Map && profile['photo_url'] == imageUrl) {
          final updatedProfile = Map<String, dynamic>.from(profile);
          updatedProfile.remove('photo_url');
          updatedProfile['updated_at'] = DateTime.now().toIso8601String();
          await _box?.put(key, updatedProfile);
        }
      }

      print('Profile image removed');
      print('Image URL: $imageUrl');
      return true;
    } catch (e) {
      throw ServerException('Failed to remove profile image: ${e.toString()}');
    }
  }
}
