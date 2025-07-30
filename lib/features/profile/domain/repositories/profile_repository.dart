/// ProfileRepository interface defines the contract for profile-related operations.
///
/// This abstract class defines all the methods that any profile repository
/// implementation must provide. It follows the repository pattern to
/// abstract data access and provide a clean API for the domain layer.
///
/// Usage Example:
///   class ProfileRepositoryImpl implements ProfileRepository {
///     @override
///     Future<Either<Failure, UserProfile>> getUserProfile(String userId) async {
///       // Implementation here
///     }
///   }
import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/features/profile/domain/entities/user_profile.dart';

/// Abstract repository interface for profile operations
abstract class ProfileRepository {
  /// Retrieves the user profile for the given user ID
  ///
  /// Returns a UserProfile entity wrapped in Either<Failure, UserProfile>
  /// where Left represents a failure and Right represents success
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - Either<Failure, UserProfile>: Success with profile data or failure
  Future<Either<Failure, UserProfileEntity>> getUserProfile(String userId);

  /// Updates the user profile information
  ///
  /// Updates the profile data for the given user and returns the updated profile
  ///
  /// Parameters:
  ///   - userProfile: The updated UserProfile entity
  ///
  /// Returns:
  ///   - Either<Failure, UserProfile>: Success with updated profile or failure
  Future<Either<Failure, UserProfileEntity>> updateUserProfile(
    {required String userId, required UserProfileEntity userProfile,}
  );

  /// Updates the user's profile image
  ///
  /// Uploads a new profile image and updates the profile with the new image URL
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///   - imagePath: Local path to the image file to upload
  ///
  /// Returns:
  ///   - Either<Failure, String>: Success with image URL or failure
  Future<Either<Failure, String>> updateProfileImage(
    String userId,
    String imagePath,
  );

  /// Updates the app language setting for the user
  ///
  /// Changes the user's preferred language and persists it locally
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///   - language: The language code (e.g., 'en', 'fa')
  ///
  /// Returns:
  ///   - Either<Failure, String>: Success with language code or failure
  Future<Either<Failure, String>> updateAppLanguage(
    String userId,
    String language,
  );

  /// Gets the current app language setting
  ///
  /// Retrieves the user's preferred language from local storage
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - Either<Failure, String>: Success with language code or failure
  Future<Either<Failure, String>> getAppLanguage(String userId);
}
