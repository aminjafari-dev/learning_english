# Localization Feature

This feature provides comprehensive localization support for the Learning English application using BLoC pattern and Clean Architecture principles.

## Architecture

The localization feature follows Clean Architecture with the following layers:

### Domain Layer
- **Entities**: `LocaleEntity` - Represents supported locales
- **Repositories**: `LocalizationRepository` - Contract for localization operations
- **Use Cases**: 
  - `GetCurrentLocaleUseCase` - Get current locale
  - `SetLocaleUseCase` - Set application locale
  - `GetSupportedLocalesUseCase` - Get all supported locales

### Data Layer
- **Models**: `LocaleModel` - Data layer model extending domain entity
- **Data Sources**: `LocalizationLocalDataSource` - Local storage operations
- **Repository Implementation**: `LocalizationRepositoryImpl` - Coordinates data operations

### Presentation Layer
- **BLoC**: `LocalizationBloc` - State management for localization
- **Events**: `LocalizationEvent` - Sealed class for all localization events
- **States**: `LocalizationState` - Sealed classes for operation states

## Supported Locales

Currently supports:
- **English** (`en_US`) - Default locale
- **Persian** (`fa_IR`) - Persian/Farsi language

## Usage

### Basic Setup

The localization system is automatically initialized in `main.dart`:

```dart
// Initialize localization BLoC
final localizationBloc = getIt<LocalizationBloc>();
localizationBloc.add(const LocalizationEvent.loadCurrentLocale());
```

### Changing Language

Use the `LanguageSelectorWidget` in the profile page:

```dart
const LanguageSelectorWidget()
```

The widget automatically:
- Displays current locale
- Allows switching between supported locales
- Persists changes to local storage
- Updates the app's locale immediately

### Programmatic Language Change

```dart
final localizationBloc = getIt<LocalizationBloc>();
localizationBloc.add(LocalizationEvent.setLocale(locale: LocaleEntity.persian));
```

### Getting Current Locale

```dart
// Access through BLoC state
final state = getIt<LocalizationBloc>().state;
final currentLocale = state.loadCurrentLocale.maybeWhen(
  orElse: () => LocaleEntity.english,
  completed: (locale) => locale,
);
```

## State Management

The localization system uses BLoC pattern with the following states:

### LoadCurrentLocaleState
- `initial` - Initial state
- `loading` - Loading current locale
- `completed(LocaleEntity)` - Successfully loaded locale
- `error(String)` - Error loading locale

### SetLocaleState
- `initial` - Initial state
- `loading` - Setting locale
- `completed(LocaleEntity)` - Successfully set locale
- `error(String)` - Error setting locale

### GetSupportedLocalesState
- `initial` - Initial state
- `loading` - Loading supported locales
- `completed(List<LocaleEntity>)` - Successfully loaded locales
- `error(String)` - Error loading locales

## Persistence

Locale settings are persisted using SharedPreferences with the key `current_locale`. The system automatically:

1. Loads the saved locale on app startup
2. Falls back to English if no locale is saved
3. Persists locale changes immediately
4. Updates the MaterialApp locale dynamically

## Integration with MaterialApp

The `main.dart` file integrates the localization system with MaterialApp using a BlocBuilder:

```dart
BlocBuilder<LocalizationBloc, LocalizationState>(
  bloc: getIt<LocalizationBloc>(),
  builder: (context, state) {
    return MaterialApp(
      locale: state.loadCurrentLocale.maybeWhen(
        orElse: () => const Locale('en'),
        completed: (locale) => locale.toLocale(),
      ),
      // ... other properties
    );
  },
)
```

## Dependencies

The localization feature is registered in the dependency injection system:

```dart
// In localization_di.dart
setupLocalizationDI(getIt);
```

All dependencies are properly registered as singletons or factories as appropriate.

## Testing

The localization system is designed to be easily testable with:
- Mockable dependencies
- Clear separation of concerns
- Predictable state management
- Isolated business logic

## Future Enhancements

Potential improvements:
- Add more supported locales
- Implement locale-specific formatting
- Add RTL support for Persian
- Implement locale fallback chains
- Add locale-specific assets loading 