/// UserProfileModel represents the data transfer object for user profile data.
///
/// This model is part of the data layer and handles the conversion between
/// JSON data and domain entities. It implements fromJson and toJson methods
/// for serialization and provides a toDomain method to convert to the domain entity.
///
/// Usage Example:
///   final model = UserProfileModel.fromJson(jsonData);
///   final entity = model.toDomain();
///   final json = model.toJson();
import 'package:learning_english/features/profile/domain/entities/user_profile.dart';

/// Data model for user profile information
class UserProfileModel extends UserProfileEntity {
  /// Constructor for UserProfileModel
  const UserProfileModel({
    super.fullName,
    super.email,
    super.profileImageUrl,
    super.phoneNumber,
    super.dateOfBirth,
    super.language,
  });

  /// Creates a UserProfileModel from JSON data
  ///
  /// This factory constructor parses JSON data and creates a UserProfileModel instance.
  /// It handles the conversion of Firestore Timestamp objects to DateTime objects.
  ///
  /// Parameters:
  ///   - json: Map containing the JSON data
  ///
  /// Returns:
  ///   - UserProfileModel: The parsed model instance
  ///
  /// Throws:
  ///   - FormatException: If the JSON data is malformed
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDateOfBirth;

    // Handle date conversion
    if (json['dateOfBirth'] != null) {
      if (json['dateOfBirth'] is String) {
        try {
          parsedDateOfBirth = DateTime.parse(json['dateOfBirth'] as String);
        } catch (e) {
          parsedDateOfBirth = null;
        }
      }
    }

    return UserProfileModel(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth: parsedDateOfBirth,
      language: json['language'] as String?,
    );
  }

  /// Converts the model to JSON format
  ///
  /// This method serializes the UserProfileModel to a JSON map.
  /// It handles the conversion of DateTime objects to ISO strings.
  ///
  /// Returns:
  ///   - Map<String, dynamic>: The JSON representation of the model
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'language': language,
    };
  }
}
