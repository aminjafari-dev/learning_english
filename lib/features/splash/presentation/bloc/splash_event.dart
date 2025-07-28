// splash_event.dart
// Events for the splash bloc.
//
// Usage Example:
//   context.read<SplashBloc>().add(const SplashEvent.checkAuthenticationStatus());

import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_event.freezed.dart';

/// Sealed class for splash-related events
@freezed
class SplashEvent with _$SplashEvent {
  /// Event to check authentication status
  const factory SplashEvent.checkAuthenticationStatus() =
      CheckAuthenticationStatus;
}
