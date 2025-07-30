/// GetUserProfileUseCase handles the business logic for retrieving user profile data.
///
/// This use case encapsulates the logic for fetching a user's profile information
/// from the repository. It follows the Clean Architecture principle of keeping
/// business logic in the domain layer.
///
/// Usage Example:
///   final useCase = GetUserProfileUseCase(profileRepository);
///   final result = await useCase.call(GetUserProfileParams(userId: currentUserId));
///   result.fold(
///     (failure) => print('Error: ${failure.message}'),
///     (profile) => print('Profile: ${profile.fullName}'),
///   );
import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/features/profile/domain/entities/user_profile.dart';
import 'package:learning_english/features/profile/domain/repositories/profile_repository.dart';

/// Parameters for getting user profile
class GetUserProfileParams {
  /// The unique identifier of the user
  final String userId;

  /// Constructor for GetUserProfileParams
  const GetUserProfileParams({required this.userId});
}

/// Use case for retrieving user profile data
class GetUserProfileUseCase
    implements UseCase<UserProfileEntity, GetUserProfileParams> {
  /// The profile repository dependency
  final ProfileRepository _profileRepository;

  /// Constructor for GetUserProfileUseCase
  ///
  /// Parameters:
  ///   - profileRepository: The repository to use for profile operations
  const GetUserProfileUseCase(this._profileRepository);

  /// Executes the use case to get user profile
  ///
  /// This method calls the repository to retrieve the user's profile information
  /// and returns the result wrapped in Either<Failure, UserProfile>
  ///
  /// Parameters:
  ///   - params: GetUserProfileParams containing the user ID
  ///
  /// Returns:
  ///   - Either<Failure, UserProfile>: Success with profile data or failure
  @override
  Future<Either<Failure, UserProfileEntity>> call(
    GetUserProfileParams params,
  ) async {
    try {
      // Call the repository to get the user profile
      final result = await _profileRepository.getUserProfile(params.userId);

      // Return the result (either success or failure)
      return result;
    } catch (e) {
      // Handle any unexpected errors and return a failure
      return Left(ServerFailure('Failed to get user profile: ${e.toString()}'));
    }
  }
}
