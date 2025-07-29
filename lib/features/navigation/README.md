# Navigation Feature

## Description
The Navigation feature provides a centralized navigation system for the Learning English application. It includes a bottom navigation bar that allows users to easily switch between the main app sections: Level Selection and Profile. This feature maintains design harmony with the existing application while providing a smooth user experience.

## Architecture

### Domain Layer
- **entities/**: Core business objects for navigation state
- **repositories/**: Abstract repository interfaces for navigation data
- **usecases/**: Business logic for navigation operations

### Data Layer
- **datasources/**: Remote and local data sources for navigation preferences
- **models/**: Data transfer objects for navigation state
- **repositories/**: Repository implementations for navigation data

### Presentation Layer
- **bloc/**: State management for navigation using BLoC pattern
- **pages/**: Main navigation page with bottom navigation bar
- **widgets/**: Reusable navigation components

## Use Cases

1. **GetNavigationStateUseCase**
   - Description: Retrieves the current navigation state and user preferences
   - Data Flow: Page -> Bloc -> UseCase -> Repository -> DataSource

2. **UpdateNavigationStateUseCase**
   - Description: Updates the current navigation state and saves user preferences
   - Data Flow: Page -> Bloc -> UseCase -> Repository -> DataSource

## Data Flow
1. User taps on a navigation item in the bottom navigation bar
2. The navigation page updates its state and calls the BLoC
3. BLoC processes the navigation event and updates the current index
4. The page rebuilds with the new content based on the selected tab
5. Navigation state is optionally saved to local storage for persistence

## Key Components
- **BottomNavBar**: Main navigation widget with two tabs (Level Selection, Profile)
- **MainNavigationPage**: Container page that manages tab switching
- **NavigationBloc**: State management for navigation operations
- **Local Storage**: Persistence for navigation preferences
- **Clean Architecture**: Proper separation of concerns
- **Design Harmony**: Uses AppTheme colors and GWidgets

## Usage
```dart
// Navigate to the main navigation page
Navigator.of(context).pushNamed(PageName.mainNavigation);

// Use the bottom navigation bar in any page
BottomNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
)
``` 