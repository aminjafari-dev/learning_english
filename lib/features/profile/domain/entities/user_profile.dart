import 'package:equatable/equatable.dart';

/// UserProfile entity represents the core business object for user profile data.
///
/// This entity is part of the domain layer and contains the essential
/// user profile information without any external dependencies.
/// It serves as the single source of truth for user profile data
/// across the application.
///
/// Usage Example:
///   final profile = UserProfile(
///     id: currentUserId,
///     fullName: 'John Doe',
///     email: 'john@example.com',
///     profileImageUrl: 'https://example.com/image.jpg',
///     phoneNumber: '+1234567890',
///     dateOfBirth: DateTime(1990, 1, 1),
///     language: 'en',
///   );
class UserProfileEntity extends Equatable {
  /// User's full name
  final String? fullName;

  /// User's email address
  final String? email;

  /// URL to the user's profile image
  final String? profileImageUrl;

  /// User's phone number
  final String? phoneNumber;

  /// User's date of birth
  final DateTime? dateOfBirth;

  /// User's preferred app language (e.g., 'en', 'fa')
  final String? language;

  /// Constructor for UserProfile entity
  const UserProfileEntity({
    this.fullName,
    this.email,
    this.profileImageUrl,
    this.phoneNumber,
    this.dateOfBirth,
    this.language,
  });

  /// Creates a copy of this UserProfile with the given fields replaced by new values
  UserProfileEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? profileImageUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? language,
  }) {
    return UserProfileEntity(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    email,
    profileImageUrl,
    phoneNumber,
    dateOfBirth,
    language,
  ];
}
