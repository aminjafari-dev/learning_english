import 'package:learning_english/features/localization/domain/entities/locale_entity.dart';

/// LocaleModel represents the data layer model for locale information.
///
/// This model extends the domain entity and provides additional functionality
/// for data layer operations such as serialization and deserialization.
/// It follows the Clean Architecture principle of having data models in the data layer.
///
/// Usage Example:
///   final model = LocaleModel.fromJson({'languageCode': 'en', 'countryCode': 'US', 'displayName': 'English'});
///   final json = model.toJson();
class LocaleModel extends LocaleEntity {
  /// Constructor for LocaleModel
  const LocaleModel({
    required super.languageCode,
    super.countryCode,
    required super.displayName,
  });

  /// Creates a LocaleModel from a JSON map
  ///
  /// Parameters:
  ///   - json: The JSON map containing locale data
  ///
  /// Returns:
  ///   - LocaleModel: The created locale model
  factory LocaleModel.fromJson(Map<String, dynamic> json) {
    return LocaleModel(
      languageCode: json['languageCode'] as String,
      countryCode: json['countryCode'] as String?,
      displayName: json['displayName'] as String,
    );
  }

  /// Converts the model to a JSON map
  ///
  /// Returns:
  ///   - Map<String, dynamic>: The JSON representation of the model
  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
      'countryCode': countryCode,
      'displayName': displayName,
    };
  }

  /// Creates a LocaleModel from a LocaleEntity
  ///
  /// Parameters:
  ///   - entity: The domain entity to convert
  ///
  /// Returns:
  ///   - LocaleModel: The created locale model
  factory LocaleModel.fromEntity(LocaleEntity entity) {
    return LocaleModel(
      languageCode: entity.languageCode,
      countryCode: entity.countryCode,
      displayName: entity.displayName,
    );
  }

  /// Converts the model to a LocaleEntity
  ///
  /// Returns:
  ///   - LocaleEntity: The domain entity
  LocaleEntity toEntity() {
    return LocaleEntity(
      languageCode: languageCode,
      countryCode: countryCode,
      displayName: displayName,
    );
  }

  /// Creates a LocaleModel for English
  static const LocaleModel english = LocaleModel(
    languageCode: 'en',
    countryCode: 'US',
    displayName: 'English',
  );

  /// Creates a LocaleModel for Persian
  static const LocaleModel persian = LocaleModel(
    languageCode: 'fa',
    countryCode: 'IR',
    displayName: 'فارسی',
  );
}
