# Daily Lessons Feature

## Description

The Daily Lessons feature provides AI-generated English vocabulary and phrases for daily learning. It follows Clean Architecture principles and includes user-specific data management, analytics, and cost optimization. **Now supports personalized content generation based on user preferences (English level and learning focus areas).**

## Architecture

The daily lessons feature is structured according to Clean Architecture principles:

### **Domain Layer**
- `entities/` - Business objects:
  - `vocabulary.dart` - Vocabulary entity with English and Persian translations
  - `phrase.dart` - Phrase entity with English and Persian translations
  - `ai_usage_metadata.dart` - Metadata for AI usage tracking and cost analysis
  - `user_preferences.dart` - **NEW**: User preferences for personalized content
- `repositories/` - Abstract repository interfaces:
  - `daily_lessons_repository.dart` - Main repository interface with personalized methods
- `usecases/` - Business logic:
  - `get_daily_vocabularies_usecase.dart` - Fetches vocabularies
  - `get_daily_phrases_usecase.dart` - Fetches phrases
  - `get_daily_lessons_usecase.dart` - **Cost-effective**: Fetches both in one request
  - `get_user_preferences_usecase.dart` - **NEW**: Fetches user preferences for personalization
  - `refresh_daily_lessons_usecase.dart` - Refreshes all content
  - `mark_vocabulary_as_used_usecase.dart` - Marks vocabulary as used
  - `mark_phrase_as_used_usecase.dart` - Marks phrase as used
  - `get_user_analytics_usecase.dart` - Gets user analytics
  - `clear_user_data_usecase.dart` - Clears user data

### **Data Layer**
- `datasources/` - Data sources:
  - `remote/` - AI providers:
    - `ai_lessons_remote_data_source.dart` - Abstract interface for AI providers
    - `openai_lessons_remote_data_source.dart` - OpenAI implementation
    - `gemini_lessons_remote_data_source.dart` - Gemini implementation
    - `deepseek_lessons_remote_data_source.dart` - DeepSeek implementation
    - `ai_prompts.dart` - **ENHANCED**: Centralized prompts with personalization support
  - `local/` - Local storage:
    - `daily_lessons_local_data_source.dart` - Hive-based local storage
- `models/` - Data models:
  - `vocabulary_model.dart` - Vocabulary data model
  - `phrase_model.dart` - Phrase data model
- `repositories/` - Repository implementations:
  - `daily_lessons_repository_impl.dart` - **ENHANCED**: Main repository with personalization

### **Presentation Layer**
- `bloc/` - State management:
  - `daily_lessons_bloc.dart` - **ENHANCED**: Main bloc with personalized events
  - `daily_lessons_event.dart` - **ENHANCED**: Events including personalized content
  - `daily_lessons_state.dart` - State management
- `pages/` - UI screens:
  - `daily_lessons_page.dart` - Main lessons page
- `widgets/` - Reusable components:
  - `daily_lessons_content.dart` - Content display widget
  - `daily_lessons_header.dart` - Header widget
  - Various other UI components

## Use Cases

### **1. Get Daily Lessons (Cost-Effective)**
- **Use Case:** `GetDailyLessonsUseCase`
- **Description:** Fetches both vocabularies and phrases in a single AI request, reducing costs by 25-40%
- **Data Flow:** Page -> Bloc -> UseCase -> Repository -> AI DataSource

### **2. Get Personalized Daily Lessons** ⭐ **NEW**
- **Use Case:** `GetUserPreferencesUseCase` + `GetDailyLessonsUseCase`
- **Description:** Fetches personalized content based on user's English level and learning focus areas
- **Data Flow:** Page -> Bloc -> GetUserPreferencesUseCase -> Repository -> User Preferences -> Personalized AI DataSource

### **3. User Data Management**
- **Use Cases:** `MarkVocabularyAsUsedUseCase`, `MarkPhraseAsUsedUseCase`, `ClearUserDataUseCase`
- **Description:** Manages user's learning progress and prevents duplicate content suggestions
- **Data Flow:** Page -> Bloc -> UseCase -> Repository -> Local DataSource

### **4. Analytics and Cost Tracking**
- **Use Case:** `GetUserAnalyticsUseCase`
- **Description:** Provides insights into learning progress and AI usage costs
- **Data Flow:** Page -> Bloc -> UseCase -> Repository -> Local DataSource

## **Personalized Content Generation** ⭐ **NEW FEATURE**

The feature now supports personalized content generation based on user preferences:

### **User Preferences Entity**
```dart
class UserPreferences {
  final Level level; // beginner, elementary, intermediate, advanced
  final List<String> focusAreas; // ['business', 'travel', 'social', etc.]
}
```

### **Enhanced AI Prompts**
The `AiPrompts` class now provides personalized prompts:
- `getPersonalizedVocabularySystemPrompt(preferences)` - Level and focus-specific vocabulary prompts
- `getPersonalizedPhraseSystemPrompt(preferences)` - Level and focus-specific phrase prompts
- `getPersonalizedLessonsSystemPrompt(preferences)` - Combined personalized prompts

### **Example Personalized Prompts**
- **Beginner + Business:** "You are an English teacher specializing in beginner level English. Provide 4 useful English vocabulary words suitable for beginner level learners, focused on these areas: business..."
- **Advanced + Travel:** "You are an English teacher specializing in advanced level English. Provide 4 useful English vocabulary words suitable for advanced level learners, focused on these areas: travel..."

### **Usage in Bloc**
```dart
// Fetch personalized content
context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchPersonalizedLessons());

// Get user preferences
context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.getUserPreferences());
```

## Data Flow

### **Standard Content Flow**
1. User opens Daily Lessons page
2. `DailyLessonsBloc` triggers `FetchLessons` event
3. `GetDailyLessonsUseCase` calls repository
4. Repository checks local cache first, then fetches from AI if needed
5. Content is saved locally and displayed to user

### **Personalized Content Flow** ⭐ **NEW**
1. User opens Daily Lessons page
2. `DailyLessonsBloc` triggers `FetchPersonalizedLessons` event
3. `GetUserPreferencesUseCase` fetches user's level and focus areas
4. Repository creates personalized AI prompts based on preferences
5. AI generates level-appropriate and focus-specific content
6. Content is saved locally with personalized context and displayed to user

## Key Components

- **AI Providers:** OpenAI, Gemini, DeepSeek with unified interface
- **Cost Optimization:** Combined requests reduce API costs by 25-40%
- **Local Storage:** Hive-based persistence with metadata tracking
- **User Analytics:** Learning progress and cost analysis
- **Personalization:** **NEW**: Level and focus-specific content generation
- **Background Sync:** Firebase integration for content sharing
- **Clean Architecture:** Separation of concerns and testability

## **Personalization Benefits** ⭐

1. **Relevant Content:** Users get vocabulary and phrases appropriate for their English level
2. **Focus-Specific Learning:** Content is tailored to user's selected learning areas (business, travel, social, etc.)
3. **Better Engagement:** Personalized content increases user engagement and learning effectiveness
4. **Progressive Learning:** Content difficulty matches user's proficiency level
5. **Contextual Learning:** Real-world vocabulary and phrases for specific situations

## Future Enhancements

- Add more AI providers for better cost optimization
- Implement content quality ratings and feedback
- Add spaced repetition algorithms
- Include pronunciation and audio features
- Expand personalization with learning style preferences
- Add content difficulty progression tracking

## Usage

To use the daily lessons feature with personalization:

```dart
// Standard usage
context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchLessons());

// Personalized usage ⭐ NEW
context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchPersonalizedLessons());

// Get user preferences
context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.getUserPreferences());
```

The personalized content will automatically adapt to the user's English level and selected learning focus areas, providing a more engaging and effective learning experience.
