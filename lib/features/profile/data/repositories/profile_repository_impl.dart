/// ProfileRepositoryImpl implements the ProfileRepository interface.
///
/// This class provides the concrete implementation of profile operations,
/// coordinating between remote and local data sources. It handles caching
/// strategies and error handling for profile-related operations.
///
/// Usage Example:
///   final repository = ProfileRepositoryImpl(
///     remoteDataSource: profileRemoteDataSource,
///     localDataSource: profileLocalDataSource,
///   );
///   final result = await repository.getUserProfile(currentUserId);
import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:learning_english/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:learning_english/features/profile/data/models/user_profile_model.dart';
import 'package:learning_english/features/profile/domain/entities/user_profile.dart';
import 'package:learning_english/features/profile/domain/repositories/profile_repository.dart';

/// Implementation of ProfileRepository
class ProfileRepositoryImpl implements ProfileRepository {
  /// Remote data source for profile operations
  final ProfileRemoteDataSource _remoteDataSource;

  /// Local data source for profile operations
  final ProfileLocalDataSource _localDataSource;

  /// Constructor for ProfileRepositoryImpl
  ///
  /// Parameters:
  ///   - remoteDataSource: The remote data source for profile operations
  ///   - localDataSource: The local data source for profile operations
  const ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required ProfileLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  /// Retrieves the user profile for the given user ID
  ///
  /// This method implements a caching strategy: first checks local storage,
  /// then falls back to remote data if needed. It caches the remote data
  /// for future offline access.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - Either<Failure, UserProfile>: Success with profile data or failure
  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile(
    String userId,
  ) async {
    try {
      // First, try to get cached profile from local storage
      final cachedProfile = await _localDataSource.getCachedProfile(userId);

      if (cachedProfile != null) {
        // Return cached profile if available
        return Right(cachedProfile);
      }

      // If no cached data, fetch from remote
      final remoteProfile = await _remoteDataSource.getUserProfile(userId);

      // Cache the remote data for future use
      await _localDataSource.cacheProfile(remoteProfile);

      return Right(remoteProfile);
    } catch (e) {
      return Left(ServerFailure('Failed to get user profile: ${e.toString()}'));
    }
  }

  /// Updates the user profile information
  ///
  /// This method updates the profile in remote storage and then updates
  /// the local cache with the new data.
  ///
  /// Parameters:
  ///   - userProfile: The updated UserProfile entity
  ///
  /// Returns:
  ///   - Either<Failure, UserProfile>: Success with updated profile or failure
  @override
  Future<Either<Failure, UserProfileEntity>> updateUserProfile(
     {  required String userId,
      required UserProfileEntity userProfile,}
  ) async {
    try {
      // Convert domain entity to model
      final userProfileModel = UserProfileModel(
        fullName: userProfile.fullName,
        email: userProfile.email,
        profileImageUrl: userProfile.profileImageUrl,
        phoneNumber: userProfile.phoneNumber,
        dateOfBirth: userProfile.dateOfBirth,
        language: userProfile.language,
      );

      // Update in remote storage
      final updatedProfile = await _remoteDataSource.updateUserProfile(
        userId: userId,
        userProfile: userProfileModel,
      );

      // Update local cache
      await _localDataSource.cacheProfile(updatedProfile);

      return Right(updatedProfile);
    } catch (e) {
      return Left(
        ServerFailure('Failed to update user profile: ${e.toString()}'),
      );
    }
  }

  /// Updates the user's profile image
  ///
  /// This method uploads the image to remote storage and returns the image URL.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///   - imagePath: Local path to the image file to upload
  ///
  /// Returns:
  ///   - Either<Failure, String>: Success with image URL or failure
  @override
  Future<Either<Failure, String>> updateProfileImage(
    String userId,
    String imagePath,
  ) async {
    try {
      // Upload image to remote storage
      final imageUrl = await _remoteDataSource.uploadProfileImage(
        userId,
        imagePath,
      );

      return Right(imageUrl);
    } catch (e) {
      return Left(
        ServerFailure('Failed to update profile image: ${e.toString()}'),
      );
    }
  }

  /// Updates the app language setting for the user
  ///
  /// This method updates the language preference in local storage.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///   - language: The language code (e.g., 'en', 'fa')
  ///
  /// Returns:
  ///   - Either<Failure, String>: Success with language code or failure
  @override
  Future<Either<Failure, String>> updateAppLanguage(
    String userId,
    String language,
  ) async {
    try {
      // Update language in local storage
      final success = await _localDataSource.setAppLanguage(userId, language);

      if (success) {
        return Right(language);
      } else {
        return Left(CacheFailure('Failed to update app language'));
      }
    } catch (e) {
      return Left(
        CacheFailure('Failed to update app language: ${e.toString()}'),
      );
    }
  }

  /// Gets the current app language setting
  ///
  /// This method retrieves the language preference from local storage.
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - Either<Failure, String>: Success with language code or failure
  @override
  Future<Either<Failure, String>> getAppLanguage(String userId) async {
    try {
      // Get language from local storage
      final language = await _localDataSource.getAppLanguage(userId);

      return Right(language);
    } catch (e) {
      return Left(CacheFailure('Failed to get app language: ${e.toString()}'));
    }
  }
}
