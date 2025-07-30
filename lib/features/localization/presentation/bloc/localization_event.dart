import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:learning_english/features/localization/domain/entities/locale_entity.dart';

part 'localization_event.freezed.dart';

/// Sealed class for localization-related events
@freezed
class LocalizationEvent with _$LocalizationEvent {
  /// Event to load current locale
  const factory LocalizationEvent.loadCurrentLocale() = LoadCurrentLocale;

  /// Event to set locale
  const factory LocalizationEvent.setLocale({required LocaleEntity locale}) =
      SetLocale;

  /// Event to get supported locales
  const factory LocalizationEvent.getSupportedLocales() = GetSupportedLocales;

  /// Event to reset localization state
  const factory LocalizationEvent.reset() = Reset;
}
