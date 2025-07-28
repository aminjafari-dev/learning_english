# Splash Feature

## Description
The splash feature serves as the initial entry point of the application. It displays a loading screen while checking the user's authentication status and redirects them to the appropriate page based on whether they are logged in or not. If the user is authenticated, they are redirected to the level selection page; otherwise, they are directed to the authentication page.

## Architecture

### Domain Layer
- **entities/**: Contains the splash entity that represents the splash state
- **repositories/**: Contains the splash repository interface for checking authentication status
- **usecases/**: Contains the check authentication status use case

### Data Layer
- **datasources/**: Contains the local data source for checking stored user ID
- **models/**: Contains data models for the splash feature
- **repositories/**: Contains the splash repository implementation

### Presentation Layer
- **bloc/**: Contains the splash bloc for state management
- **pages/**: Contains the splash page widget
- **widgets/**: Contains splash-specific widgets

## Use Cases
1. **CheckAuthenticationStatusUseCase**
   - Description: Checks if the user is authenticated by retrieving the stored user ID
   - Data Flow: SplashPage -> SplashBloc -> CheckAuthenticationStatusUseCase -> SplashRepository -> LocalDataSource

## Data Flow
1. The app starts and navigates to the splash page
2. SplashBloc triggers the CheckAuthenticationStatusUseCase
3. The use case calls the repository to get the stored user ID
4. Based on the result, the bloc emits the appropriate state
5. The splash page listens to state changes and navigates to the correct page:
   - If user ID exists: Navigate to Level Selection
   - If no user ID: Navigate to Authentication

## Key Components
- **BLoC Pattern**: For state management and authentication status checking
- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- **Repository Pattern**: For data access abstraction
- **Use Case Pattern**: For business logic encapsulation
- **Navigation**: Automatic routing based on authentication status 