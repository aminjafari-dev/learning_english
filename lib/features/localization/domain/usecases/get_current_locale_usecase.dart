import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/features/localization/domain/entities/locale_entity.dart';
import 'package:learning_english/features/localization/domain/repositories/localization_repository.dart';

/// Use case for getting the current locale setting
class GetCurrentLocaleUseCase implements UseCase<LocaleEntity, NoParams> {
  /// The localization repository dependency
  final LocalizationRepository _localizationRepository;

  /// Constructor for GetCurrentLocaleUseCase
  ///
  /// Parameters:
  ///   - localizationRepository: The repository to use for localization operations
  const GetCurrentLocaleUseCase(this._localizationRepository);

  /// Executes the use case to get the current locale
  ///
  /// This method calls the repository to get the currently selected locale.
  /// It returns the result wrapped in Either<Failure, LocaleEntity>
  ///
  /// Parameters:
  ///   - params: NoParams (no parameters needed)
  ///
  /// Returns:
  ///   - Either<Failure, LocaleEntity>: Success with current locale or failure
  @override
  Future<Either<Failure, LocaleEntity>> call(NoParams params) async {
    try {
      // Call the repository to get the current locale
      final result = await _localizationRepository.getCurrentLocale();

      // Return the result (either success or failure)
      return result;
    } catch (e) {
      // Handle any unexpected errors and return a failure
      return Left(
        ServerFailure('Failed to get current locale: ${e.toString()}'),
      );
    }
  }
}
