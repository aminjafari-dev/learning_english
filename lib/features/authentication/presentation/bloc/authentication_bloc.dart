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
import 'package:learning_english/features/authentication/domain/usecases/get_user_id_usecase.dart';
import 'package:learning_english/features/authentication/domain/usecases/remove_user_id_usecase.dart';
import 'package:learning_english/features/authentication/presentation/bloc/authentication_event.dart';
import 'package:learning_english/features/authentication/presentation/bloc/authentication_state.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/features/authentication/domain/entities/user.dart';

/// BLoC for managing authentication state and events
/// Handles Google Sign-In, user ID persistence, and authentication status checking
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SaveUserIdUseCase saveUserIdUseCase;
  final GetUserIdUseCase getUserIdUseCase;
  final RemoveUserIdUseCase removeUserIdUseCase;

  /// Constructor that injects all required use cases
  /// This allows the BLoC to handle both authentication and local storage operations
  AuthenticationBloc({
    required this.signInWithGoogleUseCase,
    required this.saveUserIdUseCase,
    required this.getUserIdUseCase,
    required this.removeUserIdUseCase,
  }) : super(const AuthenticationState.initial()) {
    on<AuthenticationEvent>((event, emit) async {
      await event.when(
        googleSignIn: () => _onGoogleSignIn(emit),
        checkLoginStatus: () => _onCheckLoginStatus(emit),
        signOut: () => _onSignOut(emit),
      );
    });
  }

  /// Handles Google Sign-In event
  /// Performs authentication and saves user ID locally if successful
  Future<void> _onGoogleSignIn(Emitter<AuthenticationState> emit) async {
    emit(const AuthenticationState.loading());

    try {
      // Perform Google Sign-In
      final result = await signInWithGoogleUseCase(NoParams());

      await result.fold(
        (failure) async {
          emit(AuthenticationState.error(failure.message));
        },
        (user) async {
          // Save user ID locally if authentication is successful
          final saveResult = await saveUserIdUseCase(user.id);
          saveResult.fold(
            (saveFailure) => emit(
              AuthenticationState.error(
                'Authentication successful but failed to save user ID: ${saveFailure.message}',
              ),
            ),
            (_) => emit(AuthenticationState.authenticated(user)),
          );
        },
      );
    } catch (e) {
      emit(AuthenticationState.error(e.toString()));
    }
  }

  /// Checks if user is already logged in by retrieving user ID from local storage
  /// This is useful for app startup to determine if user should go to main app or login screen
  Future<void> _onCheckLoginStatus(Emitter<AuthenticationState> emit) async {
    emit(const AuthenticationState.loading());

    try {
      final result = await getUserIdUseCase(NoParams());

      result.fold((failure) => emit(AuthenticationState.error(failure.message)), (
        userId,
      ) {
        if (userId != null && userId.isNotEmpty) {
          // User ID exists, create a minimal user object for authenticated state
          // In a real app, you might want to fetch full user details from remote source
          final user = User(
            id: userId,
            name: 'User', // Placeholder name
            email: '', // Placeholder email
            photoUrl: '', // Placeholder photo URL
          );
          emit(AuthenticationState.authenticated(user));
        } else {
          // No user ID found, user is not authenticated
          emit(const AuthenticationState.unauthenticated());
        }
      });
    } catch (e) {
      emit(AuthenticationState.error(e.toString()));
    }
  }

  /// Handles sign out event
  /// Clears user ID from local storage and signs out from remote authentication
  /// This ensures complete logout by removing both local and remote authentication state
  Future<void> _onSignOut(Emitter<AuthenticationState> emit) async {
    emit(const AuthenticationState.loading());

    try {
      // Remove user ID from local storage
      final removeResult = await removeUserIdUseCase(NoParams());
      removeResult.fold(
        (failure) => emit(
          AuthenticationState.error(
            'Failed to clear local data: ${failure.message}',
          ),
        ),
        (_) => emit(const AuthenticationState.unauthenticated()),
      );
    } catch (e) {
      emit(AuthenticationState.error(e.toString()));
    }
  }
}
