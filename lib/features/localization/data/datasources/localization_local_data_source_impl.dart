import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/features/localization/data/datasources/localization_local_data_source.dart';
import 'package:learning_english/features/localization/data/models/locale_model.dart';

/// Implementation of LocalizationLocalDataSource using SharedPreferences
///
/// This class provides the implementation for storing and retrieving locale
/// settings using SharedPreferences. It follows the Clean Architecture principle
/// of implementing data sources in the data layer.
///
/// Usage Example:
///   final dataSource = LocalizationLocalDataSourceImpl(sharedPreferences);
///   final currentLocale = await dataSource.getCurrentLocale();
class LocalizationLocalDataSourceImpl implements LocalizationLocalDataSource {
  /// SharedPreferences instance for local storage
  final SharedPreferences _sharedPreferences;

  /// Key for storing the current locale
  static const String _currentLocaleKey = 'current_locale';

  /// Constructor for LocalizationLocalDataSourceImpl
  ///
  /// Parameters:
  ///   - sharedPreferences: The SharedPreferences instance for local storage
  const LocalizationLocalDataSourceImpl(this._sharedPreferences);

  @override
  Future<Either<Failure, LocaleModel?>> getCurrentLocale() async {
    try {
      // Get the stored locale string from SharedPreferences
      final localeString = _sharedPreferences.getString(_currentLocaleKey);

      if (localeString == null) {
        // No locale stored, return null (will use default)
        return const Right(null);
      }

      // Parse the stored locale string
      final parts = localeString.split('_');
      if (parts.isEmpty) {
        return const Right(null);
      }

      final languageCode = parts[0];

      // Create the appropriate locale model based on language code
      LocaleModel locale;
      switch (languageCode) {
        case 'en':
          locale = LocaleModel.english;
          break;
        case 'fa':
          locale = LocaleModel.persian;
          break;
        default:
          // Unknown locale, return null (will use default)
          return const Right(null);
      }

      return Right(locale);
    } catch (e) {
      return Left(
        ServerFailure(
          'Failed to get current locale from local storage: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, LocaleModel>> setLocale(LocaleModel locale) async {
    try {
      // Store the locale string in SharedPreferences
      final localeString = locale.localeString;
      await _sharedPreferences.setString(_currentLocaleKey, localeString);

      return Right(locale);
    } catch (e) {
      return Left(
        ServerFailure('Failed to set locale in local storage: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<LocaleModel>>> getSupportedLocales() async {
    try {
      // Return all supported locales
      return Right([LocaleModel.english, LocaleModel.persian]);
    } catch (e) {
      return Left(
        ServerFailure('Failed to get supported locales: ${e.toString()}'),
      );
    }
  }
}
