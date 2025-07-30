/// UpdateProfileImageUseCase handles the business logic for updating user profile images.
///
/// This use case encapsulates the logic for uploading and updating a user's profile image
/// through the repository. It follows the Clean Architecture principle of keeping
/// business logic in the domain layer.
///
/// Usage Example:
///   final useCase = UpdateProfileImageUseCase(profileRepository);
///   final result = await useCase.call(UpdateProfileImageParams(
///     userId: currentUserId,
///     imagePath: '/path/to/image.jpg',
///   ));
///   result.fold(
///     (failure) => print('Error: ${failure.message}'),
///     (imageUrl) => print('New image URL: $imageUrl'),
///   );
import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/features/profile/domain/repositories/profile_repository.dart';

/// Parameters for updating profile image
class UpdateProfileImageParams {
  /// The unique identifier of the user
  final String userId;

  /// Local path to the image file to upload
  final String imagePath;

  /// Constructor for UpdateProfileImageParams
  const UpdateProfileImageParams({
    required this.userId,
    required this.imagePath,
  });
}

/// Use case for updating user profile image
class UpdateProfileImageUseCase
    implements UseCase<String, UpdateProfileImageParams> {
  /// The profile repository dependency
  final ProfileRepository _profileRepository;

  /// Constructor for UpdateProfileImageUseCase
  ///
  /// Parameters:
  ///   - profileRepository: The repository to use for profile operations
  const UpdateProfileImageUseCase(this._profileRepository);

  /// Executes the use case to update profile image
  ///
  /// This method calls the repository to upload the image and update the profile
  /// with the new image URL. It returns the result wrapped in Either<Failure, String>
  ///
  /// Parameters:
  ///   - params: UpdateProfileImageParams containing the user ID and image path
  ///
  /// Returns:
  ///   - Either<Failure, String>: Success with image URL or failure
  @override
  Future<Either<Failure, String>> call(UpdateProfileImageParams params) async {
    try {
      // Call the repository to update the profile image
      final result = await _profileRepository.updateProfileImage(
        params.userId,
        params.imagePath,
      );

      // Return the result (either success or failure)
      return result;
    } catch (e) {
      // Handle any unexpected errors and return a failure
      return Left(
        ServerFailure('Failed to update profile image: ${e.toString()}'),
      );
    }
  }
}
