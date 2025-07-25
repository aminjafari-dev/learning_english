# Learning Focus Selection Feature

## Description
A feature that allows users to select one or more learning focus areas (e.g., Business English, Travel English, etc.) as part of their onboarding or profile setup. Implements Clean Architecture and feature-first organization for maintainability and scalability. All user-facing strings are localized. The feature is fully tested with unit and widget tests.

## Architecture
- **Domain Layer**
  - `entities/learning_focus_option.dart` – Business object representing a learning focus option
  - `repositories/learning_focus_selection_repository.dart` – Abstract repository interface for saving/retrieving selections
  - `usecases/save_learning_focus_selection_usecase.dart` – Use case for saving selected options
- **Data Layer**
  - `repositories/learning_focus_selection_repository_impl.dart` – Repository implementation (in-memory, ready for persistent storage)
- **Presentation Layer**
  - `bloc/learning_focus_selection_cubit.dart` – Cubit for managing selection state and saving
  - `pages/learning_focus_selection_page.dart` – Main screen widget for the feature
  - `widgets/learning_focus_option_card.dart` – Reusable UI component for each option
- **Testing**
  - `test/features/learning_focus_selection/cubit/learning_focus_selection_cubit_test.dart` – Unit tests for Cubit
  - `test/features/learning_focus_selection/presentation/widgets/learning_focus_option_card_test.dart` – Widget test for option card

## Use Cases
1. **Use Case:** SaveLearningFocusSelectionUseCase  
   **Description:** Persists the selected learning focus options for the user.  
   **Data Flow:** Page -> Cubit -> UseCase -> Repository -> DataSource

## Data Flow
1. User opens the Learning Focus Selection page.
2. The page displays a grid of learning focus options (localized).
3. User selects one or more options; Cubit updates the state.
4. User taps "Continue"; Cubit triggers SaveLearningFocusSelectionUseCase.
5. The use case calls the repository to persist the selection.
6. On success, a SnackBar is shown and navigation can proceed.

## Key Components
- Flutter
- flutter_bloc
- Clean Architecture
- Feature-first organization
- Localization (intl, .arb files, AppLocalizations)
- Custom reusable widgets (GScaffold, GText, GButton, GGap)
- Theming and constants
- Unit and widget testing (flutter_test, mocktail) 