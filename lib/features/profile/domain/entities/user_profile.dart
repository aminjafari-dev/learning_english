/// UserProfile entity represents the core business object for user profile data.
///
/// This entity is part of the domain layer and contains the essential
/// user profile information without any external dependencies.
/// It serves as the single source of truth for user profile data
/// across the application.
///
/// Usage Example:
///   final profile = UserProfile(
///     id: 'user123',
///     fullName: 'John Doe',
///     email: 'john@example.com',
///     profileImageUrl: 'https://example.com/image.jpg',
///     phoneNumber: '+1234567890',
///     dateOfBirth: DateTime(1990, 1, 1),
///     language: 'en',
///   );
class UserProfile {
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

  /// User's date of birth
  final DateTime? dateOfBirth;

  /// User's preferred app language (e.g., 'en', 'fa')
  final String language;

  /// Constructor for UserProfile entity
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImageUrl,
    this.phoneNumber,
    this.dateOfBirth,
    required this.language,
  });

  /// Creates a copy of this UserProfile with the given fields replaced by new values
  UserProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? profileImageUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? language,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      language: language ?? this.language,
    );
  }

  /// Compares this UserProfile with another object for equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.fullName == fullName &&
        other.email == email &&
        other.profileImageUrl == profileImageUrl &&
        other.phoneNumber == phoneNumber &&
        other.dateOfBirth == dateOfBirth &&
        other.language == language;
  }

  /// Generates a hash code for this UserProfile
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

  /// Returns a string representation of this UserProfile
  @override
  String toString() {
    return 'UserProfile(id: $id, fullName: $fullName, email: $email, profileImageUrl: $profileImageUrl, phoneNumber: $phoneNumber, dateOfBirth: $dateOfBirth, language: $language)';
  }
}
