 # Daily Lessons Feature

## Description
The Daily Lessons feature is the heart of the application, providing users with a personalized daily learning plan. It displays vocabularies, phrases (with AI-generated English and Persian translations), and lesson sections such as Translation, Lesson, Exercise, and Exam. The feature leverages Clean Architecture and is designed for extensibility, localization, and a modern, engaging UI tailored for Iranian English learners.

## Architecture
- **Domain Layer**
  - `entities/` – Business objects (e.g., Vocabulary, Phrase, Lesson)
  - `repositories/` – Abstract repository interfaces
  - `usecases/` – Business logic use cases (fetch, refresh, etc.)
- **Data Layer**
  - `datasources/` – Remote/local data source abstractions and implementations
  - `models/` – DTOs and data models for API/local storage
  - `repositories/` – Repository implementations
- **Presentation Layer**
  - `bloc/` – Bloc/Cubit for state management
  - `pages/` – Main screen widget for daily lessons
  - `widgets/` – Reusable UI components (e.g., phrase card, section header)

## Use Cases
1. **Use Case:** FetchDailyVocabulariesUseCase  
   **Description:** Retrieves the list of daily vocabularies for the user.  
   **Data Flow:** Page -> Bloc -> UseCase -> Repository -> DataSource
2. **Use Case:** FetchDailyPhrasesUseCase  
   **Description:** Retrieves AI-generated daily phrases and their translations.  
   **Data Flow:** Page -> Bloc -> UseCase -> Repository -> DataSource
3. **Use Case:** RefreshDailyLessonsUseCase  
   **Description:** Refreshes all daily lesson content, updating vocabularies and phrases.  
   **Data Flow:** Page -> Bloc -> UseCase -> Repository -> DataSource

## Data Flow
1. User opens the Daily Lessons page.
2. Bloc dispatches fetch events for vocabularies and phrases.
3. Use cases are invoked to retrieve data from repositories.
4. Repositories coordinate with data sources (remote/local, AI) to fetch/generate data.
5. Data is mapped to domain entities and emitted as Bloc states.
6. UI widgets display the data, updating reactively.
7. User can tap "Refresh Lessons" to trigger a refresh event, repeating the flow.

## Key Components
- Clean Architecture (feature-first organization)
- flutter_bloc for state management
- freezed for immutable state/events
- OpenAI (or simulated) for phrase generation
- Flutter localization (intl, .arb files)
- Custom widgets: GScaffold, GText, GButton, GGap
- Theming via app_theme.dart
- Dependency injection (GetIt)
