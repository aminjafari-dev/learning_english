import 'package:flutter/material.dart';

/// LocaleEntity represents a supported locale in the application.
///
/// This entity encapsulates the locale information including the language code,
/// country code, and display name. It follows the Clean Architecture principle
/// of keeping domain entities independent of external frameworks.
///
/// Usage Example:
///   final locale = LocaleEntity(
///     languageCode: 'en',
///     countryCode: 'US',
///     displayName: 'English',
///   );
class LocaleEntity {
  /// The language code (e.g., 'en', 'fa')
  final String languageCode;

  /// The country code (e.g., 'US', 'IR')
  final String? countryCode;

  /// The display name of the locale (e.g., 'English', 'فارسی')
  final String displayName;

  /// Constructor for LocaleEntity
  const LocaleEntity({
    required this.languageCode,
    this.countryCode,
    required this.displayName,
  });

  /// Creates a LocaleEntity for English
  static const LocaleEntity english = LocaleEntity(
    languageCode: 'en',
    countryCode: 'US',
    displayName: 'English',
  );

  /// Creates a LocaleEntity for Persian
  static const LocaleEntity persian = LocaleEntity(
    languageCode: 'fa',
    countryCode: 'IR',
    displayName: 'فارسی',
  );

  /// Returns the locale string (e.g., 'en_US', 'fa_IR')
  String get localeString {
    if (countryCode != null) {
      return '${languageCode}_$countryCode';
    }
    return languageCode;
  }

  /// Creates a Flutter Locale object
  Locale toLocale() {
    return Locale(languageCode, countryCode);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocaleEntity &&
        other.languageCode == languageCode &&
        other.countryCode == countryCode &&
        other.displayName == displayName;
  }

  @override
  int get hashCode {
    return languageCode.hashCode ^ countryCode.hashCode ^ displayName.hashCode;
  }

  @override
  String toString() {
    return 'LocaleEntity(languageCode: $languageCode, countryCode: $countryCode, displayName: $displayName)';
  }
}
