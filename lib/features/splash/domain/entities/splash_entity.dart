// splash_entity.dart
// Entity representing the splash state and authentication status.
//
// Usage Example:
//   final splashEntity = SplashEntity(isAuthenticated: true);
//   if (splashEntity.isAuthenticated) {
//     // Navigate to level selection
//   } else {
//     // Navigate to authentication
//   }

/// Entity representing the splash state and authentication status
class SplashEntity {
  /// Whether the user is authenticated
  final bool isAuthenticated;

  /// The user ID if authenticated, null otherwise
  final String? userId;

  /// Error message if authentication check failed
  final String? errorMessage;

  /// Creates a splash entity with authentication status
  const SplashEntity({
    required this.isAuthenticated,
    this.userId,
    this.errorMessage,
  });

  /// Creates a splash entity for authenticated user
  const SplashEntity.authenticated({required String userId})
    : isAuthenticated = true,
      userId = userId,
      errorMessage = null;

  /// Creates a splash entity for unauthenticated user
  const SplashEntity.unauthenticated()
    : isAuthenticated = false,
      userId = null,
      errorMessage = null;

  /// Creates a splash entity with error
  const SplashEntity.error({required String errorMessage})
    : isAuthenticated = false,
      userId = null,
      errorMessage = errorMessage;

  /// Creates a copy of this entity with updated values
  SplashEntity copyWith({
    bool? isAuthenticated,
    String? userId,
    String? errorMessage,
  }) {
    return SplashEntity(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SplashEntity &&
        other.isAuthenticated == isAuthenticated &&
        other.userId == userId &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return isAuthenticated.hashCode ^ userId.hashCode ^ errorMessage.hashCode;
  }

  @override
  String toString() {
    return 'SplashEntity(isAuthenticated: $isAuthenticated, userId: $userId, errorMessage: $errorMessage)';
  }
}
