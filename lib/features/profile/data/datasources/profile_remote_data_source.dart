/// ProfileRemoteDataSource handles remote data operations for user profiles.
///
/// This abstract class defines the contract for remote profile operations
/// such as fetching and updating profile data from Firebase Firestore
/// and uploading images to Firebase Storage.
///
/// Usage Example:
///   class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
///     @override
///     Future<UserProfileModel> getUserProfile(String userId) async {
///       // Implementation here
///     }
///   }
import 'package:learning_english/features/profile/data/models/user_profile_model.dart';

/// Abstract remote data source for profile operations
abstract class ProfileRemoteDataSource {
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
  Future<UserProfileModel> getUserProfile(String userId);

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
  Future<UserProfileModel> updateUserProfile(UserProfileModel userProfile);

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
  Future<String> uploadProfileImage(String userId, String imagePath);

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
  Future<bool> deleteProfileImage(String imageUrl);
}
