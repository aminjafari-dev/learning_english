# Authentication Widgets

This directory contains widgets specific to the authentication feature.

## LanguageToggleButton

A widget that allows users to toggle between English and Persian languages on the authentication page.

### Features

- **Positioned**: Appears in the top-right corner of the authentication page
- **Toggle Functionality**: Switches between English (EN) and Persian (فا) languages
- **Visual Feedback**: Shows the language code that will be switched to
- **Integration**: Uses the existing LocalizationBloc for state management

### Usage

```dart
// In the authentication page
Stack(
  children: [
    // Main content
    Center(child: YourMainContent()),
    // Language toggle button overlay
    const LanguageToggleButton(),
  ],
)
```

### Implementation Details

- Uses `BlocBuilder` to listen to `LocalizationBloc` state changes
- Determines current locale from both `loadCurrentLocale` and `setLocale` states
- Dispatches `LocalizationEvent.setLocale` when tapped
- Positioned using `Positioned` widget for overlay effect
- Styled with app theme colors and rounded corners

### Dependencies

- `LocalizationBloc` - For state management
- `AppTheme` - For consistent styling
- `GText` - For text display
- `LocaleEntity` - For locale representation

### Localization

The widget displays language codes:
- `EN` for English
- `فا` for Persian (Farsi)

These are hardcoded for simplicity and consistency across the app. 