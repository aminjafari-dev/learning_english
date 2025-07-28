// splash_state.dart
// States for the splash bloc.
//
// Usage Example:
//   state.when(
//     initial: () => ...,
//     loading: () => ...,
//     authenticated: (userId) => ...,
//     unauthenticated: () => ...,
//     error: (message) => ...,
//   );

import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_state.freezed.dart';

/// Sealed class for splash states
@freezed
class SplashState with _$SplashState {
  /// Initial state when the splash page loads
  const factory SplashState.initial() = SplashInitial;

  /// Loading state while checking authentication
  const factory SplashState.loading() = SplashLoading;

  /// State when user is authenticated
  const factory SplashState.authenticated({required String userId}) =
      SplashAuthenticated;

  /// State when user is not authenticated
  const factory SplashState.unauthenticated() = SplashUnauthenticated;

  /// Error state when authentication check fails
  const factory SplashState.error({required String message}) = SplashError;
}
