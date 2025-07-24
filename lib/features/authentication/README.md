# Authentication Feature

## Description

This feature handles user authentication using Google Sign-In and manages user session data locally. It follows a Clean Architecture approach, separating concerns into domain, data, and presentation layers.

## Architecture

The authentication feature is structured according to Clean Architecture principles:

*   **Domain Layer:** Contains the core business logic and entities.
    *   `lib/features/authentication/domain/entities/user.dart`: Defines the `User` entity.
    *   `lib/features/authentication/domain/repositories/auth_repository.dart`: Defines the `AuthRepository` interface for authentication operations.
    *   `lib/features/authentication/domain/usecases/`: Contains use cases for authentication actions:
        *   `get_user_id_usecase.dart`: Retrieves the user ID locally.
        *   `save_user_id_usecase.dart`: Saves the user ID locally.
        *   `sign_in_with_google_usecase.dart`: Signs in the user with Google.
*   **Data Layer:** Handles data retrieval and storage.
    *   `lib/features/authentication/data/models/user_model.dart`: Defines the `UserModel` for mapping Firebase user data.
    *   `lib/features/authentication/data/datasources/`: Contains data sources:
        *   `auth_remote_data_source.dart`: Handles remote authentication via Firebase/Google Sign-In.
        *   `user_local_data_source.dart`: Manages local storage of the user ID using shared preferences.
    *   `lib/features/authentication/data/repositories/auth_repository_impl.dart`: Implements the `AuthRepository` using the data sources.
*   **Presentation Layer:** Contains the UI and logic for user interaction.
    *   `lib/features/authentication/presentation/bloc/`: Contains the BLoC (Business Logic Component) for managing authentication state:
        *   `authentication_bloc.dart`: Manages authentication state and events.
        *   `authentication_event.dart`: Defines authentication events.
        *   `authentication_state.dart`: Defines authentication states.
    *   `lib/features/authentication/presentation/pages/authentication_page.dart`: Implements the authentication page UI.
    *   `lib/features/authentication/presentation/widgets/google_sign_in_button.dart`: Defines the Google Sign-In button widget.

## Use Cases

1.  **Google Sign-In:**
    *   Use Case: `SignInWithGoogleUseCase`
    *   Description: Signs in the user using Google authentication.
    *   Data Flow: `AuthenticationPage` -> `AuthenticationBloc` -> `SignInWithGoogleUseCase` -> `AuthRepositoryImpl` -> `AuthRemoteDataSourceImpl`
2.  **Check Login Status:**
    *   Use Case: (Implicitly within `AuthenticationBloc`)
    *   Description: Checks if the user is already logged in (currently a TODO).
    *   Data Flow: `AuthenticationPage` -> `AuthenticationBloc`
3.  **Saving User ID:**
    *   Use Case: `SaveUserIdUseCase`
    *   Description: Saves the user ID to local storage.
    *   Data Flow: (To be implemented in the future) -> `SaveUserIdUseCase` -> `AuthRepositoryImpl` -> `UserLocalDataSourceImpl`
4.  **Retrieving User ID:**
    *   Use Case: `GetUserIdUseCase`
    *   Description: Retrieves the user ID from local storage.
    *   Data Flow: (To be implemented in the future) -> `GetUserIdUseCase` -> `AuthRepositoryImpl` -> `UserLocalDataSourceImpl`

## Data Flow

1.  The `AuthenticationPage` initiates the Google Sign-In process by dispatching a `GoogleSignIn` event to the `AuthenticationBloc`.
2.  The `AuthenticationBloc` calls the `SignInWithGoogleUseCase`.
3.  The `SignInWithGoogleUseCase` calls the `AuthRepository`.
4.  The `AuthRepositoryImpl` uses the `AuthRemoteDataSourceImpl` to authenticate with Google/Firebase.
5.  Upon successful authentication, the `AuthRemoteDataSourceImpl` returns a `UserModel`, which is converted to a `User` entity.
6.  The `AuthenticationBloc` emits an `Authenticated` state with the `User` entity, triggering navigation to the next page.

## Key Components

*   **Firebase Authentication:** Used for handling Google Sign-In.
*   **Shared Preferences:** Used for local storage of the user ID.
*   **BLoC Pattern:** Used for managing the authentication state.
*   **Clean Architecture:** Used for separation of concerns and testability.

## Future Enhancements

*   Implement the "Check Login Status" use case to persist user sessions across app restarts.
*   Add error handling and UI feedback for different authentication scenarios.
*   Implement use cases and UI components for signing out.

## Usage

To use the authentication feature:

1.  Ensure Firebase is properly configured in your Flutter project.
2.  Instantiate the `AuthenticationPage` and navigate to it.
3.  The `AuthenticationPage` will handle the Google Sign-In process and navigate to the next screen upon successful authentication.

```dart
Navigator.push(context, MaterialPageRoute(builder: (_) => AuthenticationPage()));
```