// splash_bloc.dart
// BLoC for managing splash-related operations.
//
// Usage Example:
//   BlocProvider(
//     create: (context) => getIt<SplashBloc>()..add(const SplashEvent.checkAuthenticationStatus()),
//     child: SplashPage(),
//   );

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../../domain/usecases/check_authentication_status_usecase.dart';
import 'splash_event.dart';
import 'splash_state.dart';

/// BLoC for managing splash-related operations
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final CheckAuthenticationStatusUseCase checkAuthenticationStatusUseCase;

  /// Creates a new instance of SplashBloc
  SplashBloc({required this.checkAuthenticationStatusUseCase})
    : super(const SplashState.initial()) {
    on<SplashEvent>((event, emit) async {
      await event.when(
        checkAuthenticationStatus: () => _onCheckAuthenticationStatus(emit),
      );
    });
  }

  /// Handles the check authentication status event
  /// Bypasses authentication check and goes directly to main navigation for offline mode
  Future<void> _onCheckAuthenticationStatus(Emitter<SplashState> emit) async {
    emit(const SplashState.loading());

    // Bypass authentication check and go directly to main navigation
    // This is useful when the app is offline or when you want to skip authentication
    try {
      // Add a small delay to show the splash screen briefly
      await Future.delayed(const Duration(seconds: 2));

      // Simulate authenticated user with a default user ID for offline mode
      emit(const SplashState.authenticated(userId: 'offline_user'));
    } catch (e) {
      emit(SplashState.error(message: e.toString()));
    }

    // Original authentication logic is commented out for offline mode
    // Uncomment the following code when you want to restore authentication:
    /*
    try {
      final result = await checkAuthenticationStatusUseCase.call(NoParams());

      result.fold(
        (failure) {
          emit(SplashState.error(message: failure.message));
        },
        (splashEntity) {
          if (splashEntity.isAuthenticated && splashEntity.userId != null) {
            emit(SplashState.authenticated(userId: splashEntity.userId!));
          } else if (splashEntity.errorMessage != null) {
            emit(SplashState.error(message: splashEntity.errorMessage!));
          } else {
            emit(const SplashState.unauthenticated());
          }
        },
      );
    } catch (e) {
      emit(SplashState.error(message: e.toString()));
    }
    */
  }
}
