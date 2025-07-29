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
class UserProfileModel {
  /// Unique identifier for the user profile
  final String id;

  /// User's full name
  final String fullName;

  /// User's email address
  final String email;

  /// URL to the user's profile image
  final String? profileImageUrl;

  /// User's phone number
  final String? phoneNumber;

  /// User's date of birth as ISO string
  final String? dateOfBirth;

  /// User's preferred app language (e.g., 'en', 'fa')
  final String language;

  /// Constructor for UserProfileModel
  const UserProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImageUrl,
    this.phoneNumber,
    this.dateOfBirth,
    required this.language,
  });

  /// Creates a UserProfileModel from JSON data
  ///
  /// This factory constructor parses JSON data and creates a UserProfileModel instance.
  /// It handles the conversion of date strings to DateTime objects.
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
    return UserProfileModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      language: json['language'] as String? ?? 'en', // Default to English
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
      'id': id,
      'fullName': fullName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'language': language,
    };
  }

  /// Converts the model to a domain entity
  ///
  /// This method creates a UserProfile entity from the model data.
  /// It handles the conversion of date strings to DateTime objects.
  ///
  /// Returns:
  ///   - UserProfile: The domain entity
  UserProfile toDomain() {
    DateTime? parsedDateOfBirth;
    if (dateOfBirth != null) {
      try {
        parsedDateOfBirth = DateTime.parse(dateOfBirth!);
      } catch (e) {
        // If date parsing fails, keep it as null
        parsedDateOfBirth = null;
      }
    }

    return UserProfile(
      id: id,
      fullName: fullName,
      email: email,
      profileImageUrl: profileImageUrl,
      phoneNumber: phoneNumber,
      dateOfBirth: parsedDateOfBirth,
      language: language,
    );
  }

  /// Creates a copy of this UserProfileModel with the given fields replaced by new values
  UserProfileModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? profileImageUrl,
    String? phoneNumber,
    String? dateOfBirth,
    String? language,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      language: language ?? this.language,
    );
  }

  /// Compares this UserProfileModel with another object for equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfileModel &&
        other.id == id &&
        other.fullName == fullName &&
        other.email == email &&
        other.profileImageUrl == profileImageUrl &&
        other.phoneNumber == phoneNumber &&
        other.dateOfBirth == dateOfBirth &&
        other.language == language;
  }

  /// Generates a hash code for this UserProfileModel
  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        profileImageUrl.hashCode ^
        phoneNumber.hashCode ^
        dateOfBirth.hashCode ^
        language.hashCode;
  }

  /// Returns a string representation of this UserProfileModel
  @override
  String toString() {
    return 'UserProfileModel(id: $id, fullName: $fullName, email: $email, profileImageUrl: $profileImageUrl, phoneNumber: $phoneNumber, dateOfBirth: $dateOfBirth, language: $language)';
  }
}
