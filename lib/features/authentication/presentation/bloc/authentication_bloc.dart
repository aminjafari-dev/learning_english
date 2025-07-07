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
import 'package:learning_english/features/authentication/presentation/bloc/authentication_event.dart';
import 'package:learning_english/features/authentication/presentation/bloc/authentication_state.dart';
import 'package:learning_english/core/usecase/usecase.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignInWithGoogleUseCase signInWithGoogleUseCase;

  AuthenticationBloc({required this.signInWithGoogleUseCase})
    : super(const AuthenticationState.initial()) {
    on<AuthenticationEvent>((event, emit) async {
      await event.when(
        googleSignIn: () => _onGoogleSignIn(emit),
        checkLoginStatus: () => _onCheckLoginStatus(emit),
      );
    });
  }

  Future<void> _onGoogleSignIn(Emitter<AuthenticationState> emit) async {
    emit(const AuthenticationState.loading());
    final result = await signInWithGoogleUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthenticationState.error(failure.message)),
      (user) => emit(AuthenticationState.authenticated(user)),
    );
  }

  Future<void> _onCheckLoginStatus(Emitter<AuthenticationState> emit) async {
    // TODO: Implement check for current user (call use case or repository)
    emit(const AuthenticationState.unauthenticated());
  }
}
