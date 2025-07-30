import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/features/localization/domain/entities/locale_entity.dart';
import 'package:learning_english/features/localization/domain/repositories/localization_repository.dart';

/// Parameters for setting locale
class SetLocaleParams {
  /// The locale to set
  final LocaleEntity locale;

  /// Constructor for SetLocaleParams
  const SetLocaleParams({required this.locale});
}

/// Use case for setting the application locale
class SetLocaleUseCase implements UseCase<LocaleEntity, SetLocaleParams> {
  /// The localization repository dependency
  final LocalizationRepository _localizationRepository;

  /// Constructor for SetLocaleUseCase
  ///
  /// Parameters:
  ///   - localizationRepository: The repository to use for localization operations
  const SetLocaleUseCase(this._localizationRepository);

  /// Executes the use case to set the locale
  ///
  /// This method calls the repository to set the application locale.
  /// It returns the result wrapped in Either<Failure, LocaleEntity>
  ///
  /// Parameters:
  ///   - params: SetLocaleParams containing the locale to set
  ///
  /// Returns:
  ///   - Either<Failure, LocaleEntity>: Success with set locale or failure
  @override
  Future<Either<Failure, LocaleEntity>> call(SetLocaleParams params) async {
    try {
      // Call the repository to set the locale
      final result = await _localizationRepository.setLocale(params.locale);

      // Return the result (either success or failure)
      return result;
    } catch (e) {
      // Handle any unexpected errors and return a failure
      return Left(ServerFailure('Failed to set locale: ${e.toString()}'));
    }
  }
}
