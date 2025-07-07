// authentication_state.dart
// State classes for authentication BLoC using freezed.
//
// Usage Example:
//   state.when(
//     initial: () => ...,
//     loading: () => ...,
//     authenticated: (user) => ...,
//     unauthenticated: () => ...,
//     error: (msg) => ...,
//   );
//
// This state is used in the AuthenticationBloc and UI.

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'authentication_state.freezed.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  /// Initial state
  const factory AuthenticationState.initial() = Initial;

  /// Loading state
  const factory AuthenticationState.loading() = Loading;

  /// Authenticated state with user
  const factory AuthenticationState.authenticated(User user) = Authenticated;

  /// Unauthenticated state
  const factory AuthenticationState.unauthenticated() = Unauthenticated;

  /// Error state with message
  const factory AuthenticationState.error(String message) = Error;
}
