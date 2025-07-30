import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/features/localization/domain/entities/locale_entity.dart';

/// LocalizationRepository defines the contract for localization operations.
///
/// This repository interface defines methods for getting the current locale,
/// setting a new locale, and getting all supported locales. It follows the
/// Clean Architecture principle of defining repository contracts in the domain layer.
///
/// Usage Example:
///   final repository = getIt<LocalizationRepository>();
///   final currentLocale = await repository.getCurrentLocale();
///   final result = await repository.setLocale(LocaleEntity.english);
abstract class LocalizationRepository {
  /// Gets the current locale setting
  ///
  /// Returns the currently selected locale or the default locale if none is set.
  ///
  /// Returns:
  ///   - Either<Failure, LocaleEntity>: Success with current locale or failure
  Future<Either<Failure, LocaleEntity>> getCurrentLocale();

  /// Sets the application locale
  ///
  /// Updates the locale setting and persists it locally.
  ///
  /// Parameters:
  ///   - locale: The locale to set
  ///
  /// Returns:
  ///   - Either<Failure, LocaleEntity>: Success with set locale or failure
  Future<Either<Failure, LocaleEntity>> setLocale(LocaleEntity locale);

  /// Gets all supported locales
  ///
  /// Returns a list of all locales supported by the application.
  ///
  /// Returns:
  ///   - Either<Failure, List<LocaleEntity>>: Success with supported locales or failure
  Future<Either<Failure, List<LocaleEntity>>> getSupportedLocales();
}
