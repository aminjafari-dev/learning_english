import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_english/features/localization/domain/entities/locale_entity.dart';

part 'localization_state.freezed.dart';

/// State for loading current locale
@freezed
class LoadCurrentLocaleState with _$LoadCurrentLocaleState {
  const factory LoadCurrentLocaleState.initial() = LoadCurrentLocaleInitial;
  const factory LoadCurrentLocaleState.loading() = LoadCurrentLocaleLoading;
  const factory LoadCurrentLocaleState.completed(LocaleEntity locale) =
      LoadCurrentLocaleCompleted;
  const factory LoadCurrentLocaleState.error(String message) =
      LoadCurrentLocaleError;
}

/// State for setting locale
@freezed
class SetLocaleState with _$SetLocaleState {
  const factory SetLocaleState.initial() = SetLocaleInitial;
  const factory SetLocaleState.loading() = SetLocaleLoading;
  const factory SetLocaleState.completed(LocaleEntity locale) =
      SetLocaleCompleted;
  const factory SetLocaleState.error(String message) = SetLocaleError;
}

/// State for getting supported locales
@freezed
class GetSupportedLocalesState with _$GetSupportedLocalesState {
  const factory GetSupportedLocalesState.initial() = GetSupportedLocalesInitial;
  const factory GetSupportedLocalesState.loading() = GetSupportedLocalesLoading;
  const factory GetSupportedLocalesState.completed(List<LocaleEntity> locales) =
      GetSupportedLocalesCompleted;
  const factory GetSupportedLocalesState.error(String message) =
      GetSupportedLocalesError;
}

/// Main state combining all operation states
@freezed
class LocalizationState with _$LocalizationState {
  const factory LocalizationState({
    required LoadCurrentLocaleState loadCurrentLocale,
    required SetLocaleState setLocale,
    required GetSupportedLocalesState getSupportedLocales,
  }) = _LocalizationState;
}
