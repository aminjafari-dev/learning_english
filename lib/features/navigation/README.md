# Navigation Feature

## Description
The Navigation feature provides a centralized navigation system for the Learning English application. It includes a bottom navigation bar that allows users to easily switch between the main app sections: Level Selection, Vocabulary History, and Profile. This feature maintains design harmony with the existing application while providing a smooth user experience using a simple StatefulWidget approach.

## Architecture

### Presentation Layer
- **pages/**: Main navigation page with bottom navigation bar
  - `main_navigation_page.dart`: Container page that manages tab switching using IndexedStack
- **widgets/**: Reusable navigation components
  - `bottom_nav_bar.dart`: Custom bottom navigation bar widget with three tabs

## Features

1. **Three-Tab Navigation**
   - Level Selection: For choosing English learning level
   - Vocabulary History: For viewing learning history
   - Profile: For accessing user profile settings

2. **State Management**
   - Uses StatefulWidget for simple state management
   - Maintains current tab index locally
   - Uses IndexedStack for efficient tab switching

3. **Design System Integration**
   - Uses AppTheme colors for consistent styling
   - Implements GScaffold and GText widgets
   - Supports localization for tab labels

## Data Flow
1. User taps on a navigation item in the bottom navigation bar
2. The MainNavigationPage updates its state and changes the current index
3. The IndexedStack rebuilds with the new content based on the selected tab
4. The bottom navigation bar updates its visual state to reflect the selection

## Key Components
- **MainNavigationPage**: Container page that manages tab switching using IndexedStack
- **BottomNavBar**: Custom navigation widget with three tabs (Level Selection, History, Profile)
- **IndexedStack**: Efficient widget for switching between pages without rebuilding
- **Localization**: Uses AppLocalizations for tab labels (levelSelection, history, profileTitle)
- **Design Harmony**: Uses AppTheme colors and GWidgets for consistent styling

## Usage
```dart
// Navigate to the main navigation page
Navigator.of(context).pushNamed(PageName.mainNavigation);

// Use the bottom navigation bar in any page
BottomNavBar(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
)

// Use navigation extensions
context.navigateToLevelSelection();
context.navigateToVocabularyHistory();
context.navigateToProfile();
```

## Localization
The navigation feature supports multiple languages through the following localized strings:
- `levelSelection`: Tab label for level selection
- `history`: Tab label for vocabulary history
- `profileTitle`: Tab label for profile

## Design Features
- **Custom Styling**: Each tab has a custom design with borders and background colors
- **Selection State**: Selected tabs have different styling with primary color background
- **Responsive Layout**: Uses SafeArea and proper padding for different screen sizes
- **Accessibility**: Proper touch targets and clear visual feedback 