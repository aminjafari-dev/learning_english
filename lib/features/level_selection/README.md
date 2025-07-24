# Level Selection Feature

## Description

This feature handles the selection and management of user's English proficiency level after authentication. It follows a Clean Architecture approach, separating concerns into domain, data, and presentation layers.

## Architecture

The level selection feature is structured according to Clean Architecture principles:

* **Domain Layer:** Contains the core business logic and entities.
    * `domain/entities/level.dart`: Defines the `Level` entity.
    * `domain/repositories/level_repository.dart`: Defines the `LevelRepository` interface for level operations.
    * `domain/usecases/`: Contains use cases for level selection actions:
        * `get_user_level_usecase.dart`: Retrieves the user's current level.
        * `save_user_level_usecase.dart`: Saves the selected level to Firestore.

* **Data Layer:** Handles data retrieval and storage.
    * `data/models/level_model.dart`: Defines the `LevelModel` for mapping Firestore level data.
    * `data/datasources/`: Contains data sources:
        * `level_remote_data_source.dart`: Handles remote storage via Firestore.
    * `data/repositories/level_repository_impl.dart`: Implements the `LevelRepository` using the data sources.

* **Presentation Layer:** Contains the UI and logic for user interaction.
    * `presentation/bloc/`: Contains the BLoC for managing level selection state:
        * `level_selection_bloc.dart`: Manages level selection state and events.
        * `level_selection_event.dart`: Defines level selection events.
        * `level_selection_state.dart`: Defines level selection states.
    * `presentation/pages/level_selection_page.dart`: Implements the level selection page UI.
    * `presentation/widgets/`: Contains reusable widgets for level selection UI.

## Use Cases

1. **Get User Level:**
    * Use Case: `GetUserLevelUseCase`
    * Description: Retrieves the user's current level from Firestore.
    * Data Flow: `LevelSelectionPage` -> `LevelSelectionBloc` -> `GetUserLevelUseCase` -> `LevelRepositoryImpl` -> `LevelRemoteDataSource`

2. **Save User Level:**
    * Use Case: `SaveUserLevelUseCase`
    * Description: Saves the user's selected level to Firestore.
    * Data Flow: `LevelSelectionPage` -> `LevelSelectionBloc` -> `SaveUserLevelUseCase` -> `LevelRepositoryImpl` -> `LevelRemoteDataSource`

## Data Flow

1. User navigates to the `LevelSelectionPage` after authentication
2. `LevelSelectionBloc` checks for existing level using `GetUserLevelUseCase`
3. User selects their proficiency level
4. Selection triggers a `SaveLevel` event in `LevelSelectionBloc`
5. `SaveUserLevelUseCase` stores the selection in Firestore
6. Upon successful save, user is navigated to the main content area

## Key Components

* **Firestore:** Used for storing user level preferences
* **BLoC Pattern:** Used for managing the level selection state
* **Clean Architecture:** Used for separation of concerns and testability

## Future Enhancements

* Add level assessment test to suggest appropriate level
* Implement level progression tracking
* Add detailed descriptions for each proficiency level
* Include sample content preview for each level

## Usage

To use the level selection feature:

1. Ensure user is authenticated
2. Navigate to the LevelSelectionPage:

```dart
Navigator.push(context, MaterialPageRoute(builder: (_) => LevelSelectionPage()));
```

3. The selected level will be used to personalize content throughout the app