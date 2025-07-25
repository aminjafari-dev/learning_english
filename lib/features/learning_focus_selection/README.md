# Learning Focus Selection Feature

## Description
A feature that allows users to select one or more learning focus areas (e.g., Business English, Travel English, etc.) as part of their onboarding or profile setup. Implements Clean Architecture and feature-first organization for maintainability and scalability.

## Architecture
- **Domain Layer**
  - `entities/` – Business objects (e.g., LearningFocusEntity)
  - `repositories/` – Abstract repository interfaces
  - `usecases/` – Business logic use cases
- **Data Layer**
  - `datasources/` – Remote/local data source classes
  - `models/` – Data models (DTOs)
  - `repositories/` – Repository implementations
- **Presentation Layer**
  - `bloc/` – Bloc/Cubit for state management
  - `pages/` – Main screen widget for the feature
  - `widgets/` – Reusable UI components (e.g., option cards)

## Use Cases
1. **Use Case:** SelectLearningFocusUseCase  
   **Description:** Allows the user to select one or more learning focus options.  
   **Data Flow:** Page -> Bloc -> UseCase -> Repository -> DataSource
2. **Use Case:** SaveLearningFocusUseCase  
   **Description:** Persists the selected learning focus options for the user.  
   **Data Flow:** Page -> Bloc -> UseCase -> Repository -> DataSource

## Data Flow
1. User opens the Learning Focus Selection page.
2. The page displays a grid of learning focus options.
3. User selects one or more options; Bloc updates the state.
4. User taps "Continue"; Bloc triggers SaveLearningFocusUseCase.
5. The use case calls the repository to persist the selection.
6. On success, navigation proceeds to the next step.

## Key Components
- Flutter
- flutter_bloc
- Clean Architecture
- Feature-first organization
- Localization (intl, .arb files)
- Custom reusable widgets (GScaffold, GText, GButton, GGap)
- Theming and constants 