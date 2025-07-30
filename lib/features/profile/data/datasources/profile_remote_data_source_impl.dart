/// ProfileRemoteDataSourceImpl implements remote data operations for user profiles.
///
/// This class provides concrete implementation of remote profile operations
/// using Firebase Firestore for profile data. Image upload functionality
/// is temporarily simplified until Firebase Storage is properly configured.
///
/// Usage Example:
///   final dataSource = ProfileRemoteDataSourceImpl();
///   final profile = await dataSource.getUserProfile(currentUserId);
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:learning_english/features/profile/data/models/user_profile_model.dart';

/// Implementation of ProfileRemoteDataSource
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  /// Firebase Firestore instance
  final FirebaseFirestore _firestore;

  /// Constructor for ProfileRemoteDataSourceImpl
  ///
  /// Parameters:
  ///   - firestore: Firebase Firestore instance (optional, uses default if not provided)
  ProfileRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Retrieves user profile data from remote storage
  ///
  /// This method fetches the user's profile information from Firebase Firestore
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
      final doc = await _firestore.collection('users').doc(userId).get();

      if (!doc.exists) {
        // Create default profile if user doesn't exist
        final defaultProfile = UserProfileModel(
          fullName: '',
          email: '',
          language: 'en',
        );

        await _firestore
            .collection('users')
            .doc(userId)
            .set(defaultProfile.toJson());
        return defaultProfile;
      }

      final data = doc.data() as Map<String, dynamic>;
      return UserProfileModel.fromJson(data);
    } catch (e) {
      throw ServerException('Failed to get user profile: ${e.toString()}');
    }
  }

  /// Updates user profile data in remote storage
  ///
  /// This method updates the user's profile information in Firebase Firestore
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
  }) 
   async {              
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update(userProfile.toJson());

      return userProfile;
    } catch (e) {
      throw ServerException('Failed to update user profile: ${e.toString()}');
    }
  }

  /// Uploads a profile image to remote storage
  ///
  /// This method uploads an image file to Firebase Storage and returns
  /// the public URL of the uploaded image.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///   - imagePath: Local path to the image file to upload
  ///
  /// Returns:
  ///   - String: The public URL of the uploaded image
  ///
  /// Throws:
  ///   - ServerException: If the upload operation fails
  @override
  Future<String> uploadProfileImage(String userId, String imagePath) async {
    try {
      // TODO: Implement Firebase Storage upload when dependency is properly configured
      // For now, return a placeholder URL
      return 'https://via.placeholder.com/150x150/211F12/D1A317?text=Profile';
    } catch (e) {
      throw ServerException('Failed to upload profile image: ${e.toString()}');
    }
  }

  /// Deletes a profile image from remote storage
  ///
  /// This method removes an image file from Firebase Storage.
  ///
  /// Parameters:
  ///   - imageUrl: The URL of the image to delete
  ///
  /// Returns:
  ///   - bool: True if deletion was successful
  ///
  /// Throws:
  ///   - ServerException: If the deletion operation fails
  @override
  Future<bool> deleteProfileImage(String imageUrl) async {
    try {
      // TODO: Implement Firebase Storage deletion when dependency is properly configured
      // For now, return true as placeholder
      return true;
    } catch (e) {
      throw ServerException('Failed to delete profile image: ${e.toString()}');
    }
  }
}

/// Exception thrown when server operations fail
class ServerException implements Exception {
  /// Error message
  final String message;

  /// Constructor for ServerException
  const ServerException(this.message);

  @override
  String toString() => message;
}
