# Profile Feature

## Description

This feature allows users to manage their profile information including profile image, app language settings, and complete their identity information. It follows a Clean Architecture approach, separating concerns into domain, data, and presentation layers while maintaining harmony with the existing application design and color scheme.

## Architecture

The profile feature is structured according to Clean Architecture principles:

*   **Domain Layer:** Contains the core business logic and entities.
    *   `lib/features/profile/domain/entities/user_profile.dart`: Defines the `UserProfile` entity.
    *   `lib/features/profile/domain/repositories/profile_repository.dart`: Defines the `ProfileRepository` interface for profile operations.
    *   `lib/features/profile/domain/usecases/`: Contains use cases for profile actions:
        *   `get_user_profile_usecase.dart`: Retrieves the user profile data.
        *   `update_user_profile_usecase.dart`: Updates the user profile information.
        *   `update_profile_image_usecase.dart`: Updates the user's profile image.
        *   `update_app_language_usecase.dart`: Updates the app language setting.
*   **Data Layer:** Handles data retrieval and storage.
    *   `lib/features/profile/data/models/user_profile_model.dart`: Defines the `UserProfileModel` for mapping profile data.
    *   `lib/features/profile/data/datasources/`: Contains data sources:
        *   `profile_remote_data_source.dart`: Handles remote profile operations via Firebase.
        *   `profile_local_data_source.dart`: Manages local storage of profile data using shared preferences.
    *   `lib/features/profile/data/repositories/profile_repository_impl.dart`: Implements the `ProfileRepository` using the data sources.
*   **Presentation Layer:** Contains the UI and logic for user interaction.
    *   `lib/features/profile/presentation/bloc/`: Contains the BLoC (Business Logic Component) for managing profile state:
        *   `profile_bloc.dart`: Manages profile state and events.
        *   `profile_event.dart`: Defines profile events.
        *   `profile_state.dart`: Defines profile states.
    *   `lib/features/profile/presentation/pages/profile_page.dart`: Implements the profile page UI.
    *   `lib/features/profile/presentation/widgets/`: Contains profile-specific widgets:
        *   `profile_image_widget.dart`: Widget for displaying and editing profile image.
        *   `language_selector_widget.dart`: Widget for selecting app language.
        *   `profile_info_form_widget.dart`: Widget for editing profile information.

## Use Cases

1.  **Get User Profile:**
    *   Use Case: `GetUserProfileUseCase`
    *   Description: Retrieves the current user's profile information from local storage or remote database.
    *   Data Flow: `ProfilePage` -> `ProfileBloc` -> `GetUserProfileUseCase` -> `ProfileRepositoryImpl` -> `ProfileLocalDataSourceImpl`/`ProfileRemoteDataSourceImpl`
2.  **Update User Profile:**
    *   Use Case: `UpdateUserProfileUseCase`
    *   Description: Updates the user's profile information including name, email, and other personal details.
    *   Data Flow: `ProfilePage` -> `ProfileBloc` -> `UpdateUserProfileUseCase` -> `ProfileRepositoryImpl` -> `ProfileRemoteDataSourceImpl`
3.  **Update Profile Image:**
    *   Use Case: `UpdateProfileImageUseCase`
    *   Description: Updates the user's profile image by uploading to Firebase Storage and updating the profile.
    *   Data Flow: `ProfilePage` -> `ProfileBloc` -> `UpdateProfileImageUseCase` -> `ProfileRepositoryImpl` -> `ProfileRemoteDataSourceImpl`
4.  **Update App Language:**
    *   Use Case: `UpdateAppLanguageUseCase`
    *   Description: Updates the app language setting and persists it locally.
    *   Data Flow: `ProfilePage` -> `ProfileBloc` -> `UpdateAppLanguageUseCase` -> `ProfileRepositoryImpl` -> `ProfileLocalDataSourceImpl`

## Data Flow

1.  The `ProfilePage` loads and displays the current user's profile information by dispatching a `LoadProfile` event to the `ProfileBloc`.
2.  The `ProfileBloc` calls the `GetUserProfileUseCase` to retrieve profile data.
3.  The `GetUserProfileUseCase` calls the `ProfileRepository`.
4.  The `ProfileRepositoryImpl` first checks local storage, then falls back to remote data if needed.
5.  Upon successful retrieval, the `ProfileBloc` emits a `ProfileLoaded` state with the profile data.
6.  When the user updates their profile, the `ProfilePage` dispatches an `UpdateProfile` event.
7.  The `ProfileBloc` calls the appropriate use case based on the update type (profile info, image, or language).
8.  The use case updates the data through the repository, and the `ProfileBloc` emits a `ProfileUpdated` state.

## Key Components

*   **Firebase Firestore:** Used for storing user profile data remotely.
*   **Firebase Storage:** Used for storing profile images.
*   **Shared Preferences:** Used for local storage of profile data and language settings.
*   **Image Picker:** Used for selecting profile images from device gallery or camera.
*   **BLoC Pattern:** Used for managing the profile state.
*   **Clean Architecture:** Used for separation of concerns and testability.
*   **AppTheme Colors:** Uses the existing color scheme (Gold, Dark Brown, Light Beige) for consistency.

## Design Harmony

The profile feature maintains visual harmony with the existing application by:
*   Using the established `AppTheme` colors (primaryColor, backgroundColor, surfaceColor, etc.)
*   Following the existing UI patterns with `GScaffold`, `GText`, `GButton`, and `GGap`
*   Maintaining the same card styling and input decoration themes
*   Using consistent spacing and typography from the existing theme
*   Following the established navigation patterns and page structure

## Usage

To use the profile feature:

1.  Ensure Firebase is properly configured in your Flutter project.
2.  Add the profile route to the PageRouter.
3.  Navigate to the profile page using the established navigation pattern.

```dart
Navigator.of(context).pushNamed(PageName.profile);
```

## Future Enhancements

*   Add profile verification features
*   Implement profile privacy settings
*   Add profile sharing capabilities
*   Implement profile backup and restore functionality 