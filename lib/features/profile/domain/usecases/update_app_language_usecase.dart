/// UpdateAppLanguageUseCase handles the business logic for updating app language settings.
///
/// This use case encapsulates the logic for changing the user's preferred app language
/// and persisting it locally. It follows the Clean Architecture principle of keeping
/// business logic in the domain layer.
///
/// Usage Example:
///   final useCase = UpdateAppLanguageUseCase(profileRepository);
///   final result = await useCase.call(UpdateAppLanguageParams(
///     userId: 'user123',
///     language: 'en',
///   ));
///   result.fold(
///     (failure) => print('Error: ${failure.message}'),
///     (language) => print('Language updated to: $language'),
///   );
import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/features/profile/domain/repositories/profile_repository.dart';

/// Parameters for updating app language
class UpdateAppLanguageParams {
  /// The unique identifier of the user
  final String userId;

  /// The language code to set (e.g., 'en', 'fa')
  final String language;

  /// Constructor for UpdateAppLanguageParams
  const UpdateAppLanguageParams({required this.userId, required this.language});
}

/// Use case for updating app language setting
class UpdateAppLanguageUseCase
    implements UseCase<String, UpdateAppLanguageParams> {
  /// The profile repository dependency
  final ProfileRepository _profileRepository;

  /// Constructor for UpdateAppLanguageUseCase
  ///
  /// Parameters:
  ///   - profileRepository: The repository to use for profile operations
  const UpdateAppLanguageUseCase(this._profileRepository);

  /// Executes the use case to update app language
  ///
  /// This method calls the repository to update the user's preferred language
  /// and persists it locally. It returns the result wrapped in Either<Failure, String>
  ///
  /// Parameters:
  ///   - params: UpdateAppLanguageParams containing the user ID and language code
  ///
  /// Returns:
  ///   - Either<Failure, String>: Success with language code or failure
  @override
  Future<Either<Failure, String>> call(UpdateAppLanguageParams params) async {
    try {
      // Call the repository to update the app language
      final result = await _profileRepository.updateAppLanguage(
        params.userId,
        params.language,
      );

      // Return the result (either success or failure)
      return result;
    } catch (e) {
      // Handle any unexpected errors and return a failure
      return Left(
        ServerFailure('Failed to update app language: ${e.toString()}'),
      );
    }
  }
}
