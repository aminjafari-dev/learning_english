import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/features/localization/data/datasources/localization_local_data_source.dart';
import 'package:learning_english/features/localization/data/models/locale_model.dart';
import 'package:learning_english/features/localization/domain/entities/locale_entity.dart';
import 'package:learning_english/features/localization/domain/repositories/localization_repository.dart';

/// Implementation of LocalizationRepository
///
/// This class provides the implementation for localization operations by
/// coordinating with the local data source. It follows the Clean Architecture
/// principle of implementing repositories in the data layer.
///
/// Usage Example:
///   final repository = LocalizationRepositoryImpl(localDataSource);
///   final currentLocale = await repository.getCurrentLocale();
class LocalizationRepositoryImpl implements LocalizationRepository {
  /// The local data source for locale operations
  final LocalizationLocalDataSource _localDataSource;

  /// Constructor for LocalizationRepositoryImpl
  ///
  /// Parameters:
  ///   - localDataSource: The local data source for locale operations
  const LocalizationRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, LocaleEntity>> getCurrentLocale() async {
    try {
      // Get the current locale from local storage
      final result = await _localDataSource.getCurrentLocale();

      return result.fold((failure) => Left(failure), (localeModel) {
        // If no locale is stored, return the default (English)
        if (localeModel == null) {
          return Right(LocaleModel.english.toEntity());
        }
        return Right(localeModel.toEntity());
      });
    } catch (e) {
      return Left(
        ServerFailure('Failed to get current locale: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, LocaleEntity>> setLocale(LocaleEntity locale) async {
    try {
      // Convert the entity to a model
      final localeModel = LocaleModel.fromEntity(locale);

      // Set the locale in local storage
      final result = await _localDataSource.setLocale(localeModel);

      return result.fold(
        (failure) => Left(failure),
        (storedLocale) => Right(storedLocale.toEntity()),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to set locale: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<LocaleEntity>>> getSupportedLocales() async {
    try {
      // Get supported locales from local data source
      final result = await _localDataSource.getSupportedLocales();

      return result.fold(
        (failure) => Left(failure),
        (localeModels) =>
            Right(localeModels.map((model) => model.toEntity()).toList()),
      );
    } catch (e) {
      return Left(
        ServerFailure('Failed to get supported locales: ${e.toString()}'),
      );
    }
  }
}
