# Authentication Feature

## Description

The Authentication feature provides secure user authentication using Google Sign-In with local Hive storage. This feature allows users to sign in with their Google accounts and maintains session management through local encrypted storage. All user data is stored locally on the device without requiring a backend server.

## Architecture

### Domain Layer
- **entities/user.dart** - User domain entity representing authenticated users
- **repositories/auth_repository.dart** - Abstract repository interface for authentication operations
- **usecases/sign_in_with_google_usecase.dart** - Business logic for Google Sign-In authentication

### Data Layer
- **models/user_model.dart** - Data model for mapping Google Sign-In user data with JSON serialization
- **datasources/auth_remote_data_source.dart** - Remote data source implementing Google Sign-In with local Hive storage
- **datasources/user_local_data_source.dart** - Local data source for storing user preferences
- **repositories/auth_repository_impl.dart** - Repository implementation coordinating remote and local data sources

### Presentation Layer
- **bloc/authentication_bloc.dart** - BLoC for managing authentication state and events
- **bloc/authentication_event.dart** - Events for authentication operations (sign in, sign out, check auth state)
- **bloc/authentication_state.dart** - States representing authentication status (initial, loading, authenticated, error)
- **pages/login_page.dart** - UI page for user authentication
- **widgets/** - Reusable authentication-related UI components

## Use Cases

1. **Sign In with Google**
   - **Use Case**: `SignInWithGoogleUseCase`
   - **Description**: Authenticates users using Google Sign-In and stores their data locally in Hive
   - **Data Flow**: Page -> Bloc -> UseCase -> Repository -> RemoteDataSource (Google Sign-In) -> Local Storage (Hive)

## Data Flow

1. **User initiates Google Sign-In**: User taps the Google Sign-In button on the login page
2. **BLoC processes event**: `AuthenticationBloc` receives `SignInWithGoogle` event
3. **Use Case executes**: `SignInWithGoogleUseCase` calls the repository
4. **Repository coordinates**: `AuthRepositoryImpl` calls the remote data source
5. **Google Sign-In**: `AuthRemoteDataSourceImpl` authenticates with Google and gets user credentials
6. **Local storage**: User data is stored in Hive local database
7. **User data mapping**: Google user data is mapped to `UserModel` and then to domain `User` entity
8. **State update**: BLoC emits authenticated state with user data
9. **UI update**: Login page shows authenticated user information

## Key Components

- **Local Hive Storage** - Secure local data persistence for user authentication
- **Google Sign-In** - OAuth provider for user authentication
- **BLoC Pattern** - State management for authentication flow
- **Clean Architecture** - Separation of concerns with domain, data, and presentation layers
- **Dependency Injection** - Centralized dependency management using GetIt

## Configuration

### Google Cloud Console
1. OAuth 2.0 client IDs configured:
   - **Web Client ID**: `25836737324-k6hi5ppgsi923ve3n115to3pocdv771u.apps.googleusercontent.com`
   - **Android Client ID**: `25836737324-p62t9me933469elag764l3tnvcd98ref.apps.googleusercontent.com`
   - **iOS Client ID**: `25836737324-3jqa1magg1tujgu57c59to8ho46nt4fr.apps.googleusercontent.com`
2. Package name: `com.ajo.lingo`
3. Google Sign-In API enabled

## Security Features

- **OAuth 2.0 Flow** - Secure authentication using Google's OAuth 2.0
- **Local Hive Encryption** - User data is stored securely in encrypted Hive boxes
- **Session Management** - User sessions are maintained locally
- **Error Handling** - Comprehensive error handling for authentication failures

## Usage Examples

### Sign In with Google
```dart
// Get the authentication bloc
final authBloc = getIt<AuthenticationBloc>();

// Trigger Google Sign-In
authBloc.add(const AuthenticationEvent.signInWithGoogle());

// Listen to authentication state changes
BlocBuilder<AuthenticationBloc, AuthenticationState>(
  builder: (context, state) {
    return state.when(
      initial: () => LoginButton(),
      loading: () => CircularProgressIndicator(),
      authenticated: (user) => UserProfile(user: user),
      error: (message) => ErrorWidget(message: message),
    );
  },
);
```

### Check Current User
```dart
// Get current authenticated user
final user = await getIt<AuthRepository>().getCurrentUser();
if (user != null) {
  print('User is signed in: ${user.name}');
} else {
  print('No user signed in');
}
```

### Sign Out
```dart
// Sign out user
await getIt<AuthRepository>().signOut();
```

## Error Handling

The authentication feature handles various error scenarios:
- **Google Sign-In cancellation** - User cancels the sign-in process
- **Network errors** - Connection issues during authentication
- **Local storage errors** - Issues with Hive database operations
- **Token validation errors** - Invalid or expired authentication tokens

All errors are properly caught and converted to user-friendly error messages through the BLoC pattern.

## Data Storage

User authentication data is stored locally using Hive:
- User credentials are saved in `auth_users` box
- Session data is maintained in `auth_box`
- User profile data is stored in `user_profiles` box

All data is stored on the device and does not require an internet connection for retrieval after initial sign-in.
