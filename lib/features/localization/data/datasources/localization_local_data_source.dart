import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/features/localization/data/models/locale_model.dart';

/// LocalizationLocalDataSource defines the contract for local localization operations.
///
/// This data source interface defines methods for persisting and retrieving
/// locale settings from local storage. It follows the Clean Architecture principle
/// of defining data source contracts in the data layer.
///
/// Usage Example:
///   final dataSource = getIt<LocalizationLocalDataSource>();
///   final currentLocale = await dataSource.getCurrentLocale();
///   final result = await dataSource.setLocale(LocaleModel.english);
abstract class LocalizationLocalDataSource {
  /// Gets the current locale from local storage
  ///
  /// Returns the currently stored locale or null if none is stored.
  ///
  /// Returns:
  ///   - Either<Failure, LocaleModel?>: Success with current locale or failure
  Future<Either<Failure, LocaleModel?>> getCurrentLocale();

  /// Sets the locale in local storage
  ///
  /// Persists the locale setting to local storage.
  ///
  /// Parameters:
  ///   - locale: The locale to store
  ///
  /// Returns:
  ///   - Either<Failure, LocaleModel>: Success with stored locale or failure
  Future<Either<Failure, LocaleModel>> setLocale(LocaleModel locale);

  /// Gets all supported locales
  ///
  /// Returns a list of all locales supported by the application.
  ///
  /// Returns:
  ///   - Either<Failure, List<LocaleModel>>: Success with supported locales or failure
  Future<Either<Failure, List<LocaleModel>>> getSupportedLocales();
}
