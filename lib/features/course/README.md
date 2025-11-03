# Courses Feature

## Description

The Courses feature provides AI-generated English vocabulary and phrases for course learning. It follows Clean Architecture principles with a simplified, focused architecture that emphasizes personalized content generation based on user preferences (level and learning focus areas). The feature generates course content with vocabularies and phrases tailored to the user's learning needs.

## Architecture

The courses feature is structured according to Clean Architecture principles with a simplified, focused approach:

### **Domain Layer**
- `entities/` - Business objects:
  - `vocabulary.dart` - Vocabulary entity with English and Persian translations
  - `phrase.dart` - Phrase entity with English and Persian translations
  - `learning_request.dart` - Learning request entity for tracking lesson generation
  - `user_preferences.dart` - User preferences for personalized content (level and focus areas)
- `repositories/` - Abstract repository interfaces:
  - `courses_repository.dart` - Core course generation repository
  - `user_preferences_repository.dart` - User preferences management repository
- `usecases/` - Business logic:
  - `get_courses_usecase.dart` - Fetches personalized courses based on user preferences
  - `get_user_preferences_usecase.dart` - Fetches user preferences for personalization
  - `complete_course_usecase.dart` - Handles course completion

### **Data Layer**
- `datasources/` - Data sources:
  - `remote/` - AI services:
    - `gemini_lessons_service.dart` - Gemini AI service for course generation
    - `lesson_prompts.dart` - Centralized prompts for course generation
  - `local/` - Local storage (composition pattern):
    - `courses_local_data_source.dart` - Main coordinator using composition
    - `learning_requests_local_data_source.dart` - Learning request CRUD operations
    - `course_content_local_data_source.dart` - Course content storage
- `models/` - Data models:
  - `vocabulary_model.dart` - Vocabulary data model with Hive adapter
  - `phrase_model.dart` - Phrase data model with Hive adapter
  - `learning_request_model.dart` - Learning request data model with Hive adapter
  - `ai_provider_type.dart` - AI provider enumeration
  - `level_type.dart` - User level enumeration
- `repositories/` - Repository implementations:
  - `courses_repository_impl.dart` - Core course generation implementation
  - `user_preferences_repository_impl.dart` - User preferences management implementation

### **Presentation Layer**
- `bloc/` - State management:
  - `courses_bloc.dart` - Main bloc with course generation functionality
  - `courses_event.dart` - Events: fetchLessons, refreshLessons, getUserPreferences, fetchLessonsWithCourseContext, completeCourse
  - `courses_state.dart` - Combined state management for courses, preferences, analytics, and course completion
- `pages/` - UI screens:
  - `courses_page.dart` - Main courses page
- `widgets/` - Reusable components:
  - `courses_content.dart` - Content display widget
  - `courses_header.dart` - Header widget
  - `phrase_card.dart` - Phrase card widget
  - `section_header.dart` - Section header widget
  - `user_preferences_display.dart` - User preferences display widget
  - `course_completion_button.dart` - Course completion button widget
  - `next_lessons_button.dart` - Next lessons button widget

## Use Cases

### **1. Get Personalized Courses** ⭐
- **Use Case:** `GetCoursesUseCase`
- **Description:** Fetches personalized vocabularies and phrases based on user preferences (level and focus areas)
- **Data Flow:** Page -> Bloc -> UseCase -> Repository -> Gemini Service -> Local Storage

### **2. Get User Preferences**
- **Use Case:** `GetUserPreferencesUseCase`
- **Description:** Fetches user's English level and learning focus areas for content personalization
- **Data Flow:** Page -> Bloc -> UseCase -> UserPreferencesRepository -> Level/Focus Repositories

### **3. Complete Course**
- **Use Case:** `CompleteCourseUseCase`
- **Description:** Completes a course and unlocks the next one in the learning path
- **Data Flow:** Page -> Bloc -> UseCase -> CoursesRepository -> LearningPathsRepository

## **Personalized Content Generation** ⭐

The feature supports personalized content generation based on user preferences:

### **User Preferences Entity**
```dart
class UserPreferences {
  final Level level; // beginner, elementary, intermediate, advanced
  final List<String> focusAreas; // ['business', 'travel', 'social', etc.]
}
```

### **Lesson Prompts**
The `LessonPrompts` class provides personalized prompts:
- `getLessonPrompt(preferences)` - Level and focus-specific lesson prompts
- `getCourseLessonPrompt(preferences, courseTitle, courseNumber)` - Course-specific lesson prompts

### **AI Service**
The `GeminiLessonsService` handles AI interactions:
- Direct API calls to Google's Gemini API
- JSON response parsing and validation
- Error handling and retry logic
- Supports both general and course-specific lesson generation

## Data Flow

1. **User launches Courses page**
   - BLoC is created via `BlocProvider`
   - Initial state is set with all states as `initial()`

2. **Fetch courses event is triggered**
   - `FetchLessons` event is added to the BLoC
   - BLoC emits loading states for vocabularies, phrases, and preferences
   - User preferences are fetched from local storage
   - Gemini service generates courses based on preferences
   - AI response is parsed to extract vocabularies and phrases
   - Generated content is saved to local storage for tracking
   - BLoC emits loaded states with the data

3. **User views courses**
   - UI displays vocabularies and phrases using widgets
   - User preferences are shown in the header
   - Each vocabulary/phrase is displayed in a card

4. **Course-specific lessons**
   - `FetchLessonsWithCourseContext` event is added with path and course info
   - Repository checks for existing course content in local storage
   - If not found, generates new content using course-specific prompts
   - Saves course content for future use
   - BLoC emits loaded states with course-specific data

5. **Course completion**
   - `CompleteCourse` event is added with path and course number
   - Repository updates learning path progress
   - Unlocks next course in the learning path
   - BLoC emits completed state

## Key Components

- **Gemini AI** - Google's Gemini API for generating personalized lessons
- **BLoC** - State management for lesson generation and user preferences
- **Hive** - Local storage for caching lessons and tracking analytics
- **Clean Architecture** - Separation of concerns across domain, data, and presentation layers
- **Dartz** - Functional programming with `Either` for error handling
- **Freezed** - Immutable state and event classes

## Local Storage

The feature uses Hive for local storage:
- **Learning Requests** - Tracks all lesson generation requests with metadata
- **Course Content** - Caches course-specific lessons for offline access
- **User Preferences** - Stores user level and focus areas

## Error Handling

The feature implements comprehensive error handling:
- **Network Errors** - Handled with fallback to cached content
- **AI Service Errors** - Logged and displayed to user
- **Parsing Errors** - Returns empty lists with error messages
- **State Management Errors** - Uses `emit.isDone` checks to prevent emission after disposal

## Testing

The feature supports testing with:
- **Unit Tests** - Test use cases, repositories, and services
- **Widget Tests** - Test UI components and user interactions
- **Integration Tests** - Test complete user flows

## Future Enhancements

- Add support for multiple AI providers (OpenAI, Anthropic, etc.)
- Implement lesson history and progress tracking
- Add gamification features (streaks, achievements, etc.)
- Support offline lesson generation with cached AI responses
- Add lesson difficulty adjustment based on user performance
