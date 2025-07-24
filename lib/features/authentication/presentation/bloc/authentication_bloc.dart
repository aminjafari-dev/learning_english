// authentication_bloc.dart
// BLoC for managing authentication state and events.
//
// Usage Example:
//   BlocProvider(
//     create: (_) => getIt<AuthenticationBloc>(),
//     child: AuthenticationPage(),
//   );
//
// This BLoC handles Google Sign-In and authentication state.

import 'package:bloc/bloc.dart';
import 'package:learning_english/features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:learning_english/features/authentication/domain/usecases/save_user_id_usecase.dart';
import 'package:learning_english/features/authentication/presentation/bloc/authentication_event.dart';
import 'package:learning_english/features/authentication/presentation/bloc/authentication_state.dart';
import 'package:learning_english/core/usecase/usecase.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SaveUserIdUseCase saveUserIdUseCase;

  AuthenticationBloc({
    required this.signInWithGoogleUseCase,
    required this.saveUserIdUseCase,
  }) : super(const AuthenticationState.initial()) {
    on<AuthenticationEvent>((event, emit) async {
      await event.when(
        googleSignIn: () => _onGoogleSignIn(emit),
        checkLoginStatus: () => _onCheckLoginStatus(emit),
      );
    });
  }

  Future<void> _onGoogleSignIn(Emitter<AuthenticationState> emit) async {
    try {
      emit(const AuthenticationState.loading());
      final result = await signInWithGoogleUseCase(NoParams());

      await result.fold(
        (failure) async => emit(AuthenticationState.error(failure.message)),
        (user) async {
          try {
            // Save user ID locally after successful authentication
            final saveResult = await saveUserIdUseCase(user.id);
            saveResult.fold(
              (failure) => emit(AuthenticationState.error(failure.message)),
              (_) => emit(AuthenticationState.authenticated(user)),
            );
          } catch (e) {
            emit(
              AuthenticationState.error(
                'Failed to save user data: ${e.toString()}',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(AuthenticationState.error('Authentication failed: ${e.toString()}'));
    }
  }

  Future<void> _onCheckLoginStatus(Emitter<AuthenticationState> emit) async {
    try {
      // TODO: Implement check for current user (call use case or repository)
      emit(const AuthenticationState.unauthenticated());
    } catch (e) {
      emit(
        AuthenticationState.error(
          'Failed to check login status: ${e.toString()}',
        ),
      );
    }
  }
}
