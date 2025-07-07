// authentication_event.dart
// Sealed class for authentication-related events using freezed.
//
// Usage Example:
//   context.read<AuthenticationBloc>().add(const AuthenticationEvent.googleSignIn());
//   context.read<AuthenticationBloc>().add(const AuthenticationEvent.checkLoginStatus());
//
// This helps manage all authentication events in a type-safe way.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_event.freezed.dart';

@freezed
class AuthenticationEvent with _$AuthenticationEvent {
  /// Event to trigger Google Sign-In
  /// Useful for starting the Google authentication flow.
  /// Example:
  ///   context.read<AuthenticationBloc>().add(const AuthenticationEvent.googleSignIn());
  const factory AuthenticationEvent.googleSignIn() = GoogleSignIn;

  /// Event to check if the user is already logged in
  /// Useful for splash screen or app start.
  /// Example:
  ///   context.read<AuthenticationBloc>().add(const AuthenticationEvent.checkLoginStatus());
  const factory AuthenticationEvent.checkLoginStatus() = CheckLoginStatus;
}
