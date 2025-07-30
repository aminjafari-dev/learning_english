import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/features/localization/domain/entities/locale_entity.dart';
import 'package:learning_english/features/localization/domain/repositories/localization_repository.dart';

/// Use case for getting all supported locales
class GetSupportedLocalesUseCase
    implements UseCase<List<LocaleEntity>, NoParams> {
  /// The localization repository dependency
  final LocalizationRepository _localizationRepository;

  /// Constructor for GetSupportedLocalesUseCase
  ///
  /// Parameters:
  ///   - localizationRepository: The repository to use for localization operations
  const GetSupportedLocalesUseCase(this._localizationRepository);

  /// Executes the use case to get supported locales
  ///
  /// This method calls the repository to get all supported locales.
  /// It returns the result wrapped in Either<Failure, List<LocaleEntity>>
  ///
  /// Parameters:
  ///   - params: NoParams (no parameters needed)
  ///
  /// Returns:
  ///   - Either<Failure, List<LocaleEntity>>: Success with supported locales or failure
  @override
  Future<Either<Failure, List<LocaleEntity>>> call(NoParams params) async {
    try {
      // Call the repository to get supported locales
      final result = await _localizationRepository.getSupportedLocales();

      // Return the result (either success or failure)
      return result;
    } catch (e) {
      // Handle any unexpected errors and return a failure
      return Left(
        ServerFailure('Failed to get supported locales: ${e.toString()}'),
      );
    }
  }
}
