# Learning Focus Feature

## Description

This feature allows users to select their preferred learning focus areas for English learning. It provides a grid-based interface with 12 different learning categories (Business, Travel, Social, Home, Academic, Movie, Music, TV, Shopping, Restaurant, Health, and Everyday English) and saves user preferences to Firestore. The feature follows Clean Architecture principles, separating concerns into domain, data, and presentation layers.

## Architecture

The learning focus feature is structured according to Clean Architecture principles:

* **Domain Layer:** Contains the core business logic and entities.
    * `lib/features/learning_focus/domain/entities/learning_focus.dart`: Defines the `LearningFocus` entity with focus types and selection state.
    * `lib/features/learning_focus/domain/entities/user_learning_focus.dart`: Defines the `UserLearningFocus` entity for storing user preferences.
    * `lib/features/learning_focus/domain/repositories/learning_focus_repository.dart`: Defines the `LearningFocusRepository` interface for learning focus operations.
    * `lib/features/learning_focus/domain/usecases/`: Contains use cases for learning focus actions:
        * `get_learning_focus_options_usecase.dart`: Retrieves all available learning focus options.
        * `save_user_learning_focus_usecase.dart`: Saves user's selected learning focus preferences.
        * `get_user_learning_focus_usecase.dart`: Retrieves user's saved learning focus preferences.

* **Data Layer:** Handles data retrieval and storage.
    * `lib/features/learning_focus/data/models/learning_focus_model.dart`: Defines the `LearningFocusModel` for JSON serialization.
    * `lib/features/learning_focus/data/models/user_learning_focus_model.dart`: Defines the `UserLearningFocusModel` for JSON serialization.
    * `lib/features/learning_focus/data/datasources/`: Contains data sources:
        * `learning_focus_local_data_source.dart`: Provides predefined learning focus options locally.
        * `learning_focus_remote_data_source.dart`: Handles remote storage of user preferences via Firestore.
    * `lib/features/learning_focus/data/repositories/learning_focus_repository_impl.dart`: Implements the `LearningFocusRepository` using data sources.

* **Presentation Layer:** Contains the UI and logic for user interaction.
    * `lib/features/learning_focus/presentation/bloc/`: Contains the BLoC for managing learning focus state:
        * `learning_focus_bloc.dart`: Manages learning focus state and events.
        * `learning_focus_event.dart`: Defines learning focus events.
        * `learning_focus_state.dart`: Defines learning focus states.
    * `lib/features/learning_focus/presentation/pages/learning_focus_page.dart`: Implements the main learning focus selection page.
    * `lib/features/learning_focus/presentation/widgets/`: Contains reusable widgets:
        * `learning_focus_card.dart`: Individual learning focus option card widget.
        * `learning_focus_grid.dart`: Grid layout widget for displaying all options.

## Use Cases

1. **Load Learning Focus Options:**
    * Use Case: `GetLearningFocusOptionsUseCase`
    * Description: Retrieves all 12 predefined learning focus options from local data source.
    * Data Flow: `LearningFocusPage` -> `LearningFocusBloc` -> `GetLearningFocusOptionsUseCase` -> `LearningFocusRepositoryImpl` -> `LearningFocusLocalDataSourceImpl`

2. **Toggle Focus Selection:**
    * Use Case: (Handled within `LearningFocusBloc`)
    * Description: Allows users to select/deselect learning focus options with visual feedback.
    * Data Flow: `LearningFocusCard` -> `LearningFocusBloc` (ToggleSelection event)

3. **Save User Preferences:**
    * Use Case: `SaveUserLearningFocusUseCase`
    * Description: Saves the user's selected learning focus preferences to Firestore.
    * Data Flow: `LearningFocusPage` -> `LearningFocusBloc` -> `SaveUserLearningFocusUseCase` -> `LearningFocusRepositoryImpl` -> `LearningFocusRemoteDataSourceImpl`

4. **Load User Preferences:**
    * Use Case: `GetUserLearningFocusUseCase`
    * Description: Retrieves user's previously saved learning focus preferences.
    * Data Flow: `LearningFocusPage` -> `LearningFocusBloc` -> `GetUserLearningFocusUseCase` -> `LearningFocusRepositoryImpl` -> `LearningFocusRemoteDataSourceImpl`

## Data Flow

1. The `LearningFocusPage` is initialized and loads all available learning focus options via `LoadOptions` event.
2. The `LearningFocusBloc` calls `GetLearningFocusOptionsUseCase` to retrieve predefined options.
3. Options are displayed in a responsive grid layout using `LearningFocusGrid` and `LearningFocusCard` widgets.
4. Users can tap on cards to select/deselect options, triggering `ToggleSelection` events.
5. The BLoC updates the selection state and refreshes the UI with visual feedback.
6. When users tap "Continue", a `SaveSelections` event is dispatched with the user ID.
7. The `SaveUserLearningFocusUseCase` saves preferences to Firestore via the remote data source.
8. Upon successful save, users receive confirmation and can navigate to the next screen.

## Key Components

* **Firestore:** Used for storing user learning focus preferences with timestamps.
* **Local Data Source:** Provides predefined learning focus options with icons and titles.
* **BLoC Pattern:** Used for managing selection state and user interactions.
* **Clean Architecture:** Used for separation of concerns and testability.
* **Responsive Grid:** Displays options in a 2-column grid layout that adapts to screen size.

## Future Enhancements

* Add support for custom learning focus categories created by users.
* Implement analytics to track popular learning focus combinations.
* Add recommendation system based on user level and previous selections.
* Support for multiple language interfaces (currently supports English with Persian back button).
* Add onboarding tooltips to explain each learning focus category.

## Usage

To use the learning focus feature:

1. Ensure Firestore is properly configured in your Flutter project.
2. Register the learning focus dependencies in your dependency injection setup.
3. Navigate to the `LearningFocusPage` with a valid user ID.

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => LearningFocusPage(userId: 'user123'),
  ),
);
```

The page will handle the learning focus selection process and save preferences to Firestore upon completion.
