/// UpdateUserProfileUseCase handles the business logic for updating user profile data.
///
/// This use case encapsulates the logic for updating a user's profile information
/// through the repository. It follows the Clean Architecture principle of keeping
/// business logic in the domain layer.
///
/// Usage Example:
///   final useCase = UpdateUserProfileUseCase(profileRepository);
///   final result = await useCase.call(UpdateUserProfileParams(userProfile: updatedProfile));
///   result.fold(
///     (failure) => print('Error: ${failure.message}'),
///     (profile) => print('Updated Profile: ${profile.fullName}'),
///   );
import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/features/profile/domain/entities/user_profile.dart';
import 'package:learning_english/features/profile/domain/repositories/profile_repository.dart';

/// Parameters for updating user profile
class UpdateUserProfileParams {
  /// The updated user profile entity
  final UserProfile userProfile;

  /// Constructor for UpdateUserProfileParams
  const UpdateUserProfileParams({required this.userProfile});
}

/// Use case for updating user profile data
class UpdateUserProfileUseCase
    implements UseCase<UserProfile, UpdateUserProfileParams> {
  /// The profile repository dependency
  final ProfileRepository _profileRepository;

  /// Constructor for UpdateUserProfileUseCase
  ///
  /// Parameters:
  ///   - profileRepository: The repository to use for profile operations
  const UpdateUserProfileUseCase(this._profileRepository);

  /// Executes the use case to update user profile
  ///
  /// This method calls the repository to update the user's profile information
  /// and returns the result wrapped in Either<Failure, UserProfile>
  ///
  /// Parameters:
  ///   - params: UpdateUserProfileParams containing the updated profile data
  ///
  /// Returns:
  ///   - Either<Failure, UserProfile>: Success with updated profile or failure
  @override
  Future<Either<Failure, UserProfile>> call(
    UpdateUserProfileParams params,
  ) async {
    try {
      // Call the repository to update the user profile
      final result = await _profileRepository.updateUserProfile(
        params.userProfile,
      );

      // Return the result (either success or failure)
      return result;
    } catch (e) {
      // Handle any unexpected errors and return a failure
      return Left(
        ServerFailure('Failed to update user profile: ${e.toString()}'),
      );
    }
  }
}
