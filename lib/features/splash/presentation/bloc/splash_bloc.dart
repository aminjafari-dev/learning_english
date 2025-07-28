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
  Future<void> _onCheckAuthenticationStatus(Emitter<SplashState> emit) async {
    emit(const SplashState.loading());

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
  }
}
