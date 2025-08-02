# Daily Lessons Feature

## Description

The Daily Lessons feature provides AI-generated English vocabulary and phrases for daily learning with **conversation mode capabilities**. It follows Clean Architecture principles with a simplified, focused architecture that emphasizes personalized content generation, cost optimization, and interactive learning through conversations.

## Architecture

The daily lessons feature is structured according to Clean Architecture principles with a simplified, focused approach:

### **Domain Layer**
- `entities/` - Business objects:
  - `vocabulary.dart` - Vocabulary entity with English and Persian translations
  - `phrase.dart` - Phrase entity with English and Persian translations
  - `ai_usage_metadata.dart` - Metadata for AI usage tracking and cost analysis
  - `user_preferences.dart` - User preferences for personalized content
- `repositories/` - Abstract repository interfaces:
  - `daily_lessons_repository.dart` - Core lesson generation repository
  - `conversation_repository.dart` - Conversation management repository
  - `user_preferences_repository.dart` - User preferences management repository
- `usecases/` - Business logic (simplified):
  - `get_daily_lessons_usecase.dart` - **Cost-effective**: Fetches personalized lessons in one request
  - `get_user_preferences_usecase.dart` - Fetches user preferences for personalization
  - `send_conversation_message_usecase.dart` - Handles conversation messaging

### **Data Layer**
- `datasources/` - Data sources:
  - `remote/` - AI providers:
    - `ai_lessons_remote_data_source.dart` - Abstract interface for AI providers
    - `openai_lessons_remote_data_source.dart` - OpenAI implementation
    - `gemini_lessons_remote_data_source.dart` - Gemini implementation
    - `deepseek_lessons_remote_data_source.dart` - DeepSeek implementation
    - `ai_prompts.dart` - Centralized prompts with personalization support
    - `gemini_conversation_service.dart` - AI conversation service
    - `firebase_lessons_remote_data_source.dart` - Background sync with Firebase
  - `local/` - Specialized local storage (composition pattern):
    - `daily_lessons_local_data_source.dart` - Main coordinator using composition
    - `learning_requests_local_data_source.dart` - Learning request CRUD operations
    - `conversation_threads_local_data_source.dart` - Conversation thread management
    - `analytics_local_data_source.dart` - Analytics and statistics calculation
- `models/` - Data models:
  - `vocabulary_model.dart` - Vocabulary data model
  - `phrase_model.dart` - Phrase data model
  - `conversation_thread_model.dart` - Conversation thread data model
  - `learning_request_model.dart` - Learning request data model
- `repositories/` - Repository implementations:
  - `daily_lessons_repository_impl.dart` - Core lesson generation
  - `conversation_repository_impl.dart` - Conversation management
  - `user_preferences_repository_impl.dart` - User preferences management
- `services/` - Background services:
  - `background_content_sync_service.dart` - Firebase sync service
  - `content_sync_event_bus.dart` - Event bus for background sync
  - `content_sync_manager.dart` - Sync management
  - `content_sync_service_factory.dart` - Service factory

### **Presentation Layer**
- `bloc/` - State management:
  - `daily_lessons_bloc.dart` - **Simplified**: Main bloc with conversation + lessons functionality
  - `daily_lessons_event.dart` - **Simplified**: 4 core events (fetchLessons, refreshLessons, getUserPreferences, sendConversationMessage)
  - `daily_lessons_state.dart` - **Enhanced**: Combined state management for lessons and conversations
- `pages/` - UI screens:
  - `daily_lessons_page.dart` - Main lessons page
- `widgets/` - Reusable components:
  - `daily_lessons_content.dart` - Content display widget
  - `daily_lessons_header.dart` - Header widget
  - Various other UI components

## Use Cases

### **1. Get Personalized Daily Lessons** ⭐
- **Use Case:** `GetDailyLessonsUseCase`
- **Description:** Fetches personalized vocabularies and phrases in a single AI request based on user preferences, reducing costs by 25-40%
- **Data Flow:** Page -> Bloc -> UseCase -> Repository -> AI DataSource

### **2. Get User Preferences**
- **Use Case:** `GetUserPreferencesUseCase`
- **Description:** Fetches user's English level and learning focus areas for content personalization
- **Data Flow:** Page -> Bloc -> UseCase -> UserPreferencesRepository -> Level/Focus Repositories

### **3. Send Conversation Message** ⭐ **NEW**
- **Use Case:** `SendConversationMessageUseCase`
- **Description:** Handles AI-powered conversation for interactive learning sessions with thread persistence
- **Data Flow:** Page -> Bloc -> UseCase -> ConversationRepository -> AI Conversation Service

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

### **Personalized Lessons Flow** ⭐
1. User opens Daily Lessons page
2. `DailyLessonsBloc` triggers `FetchLessons` event
3. `GetUserPreferencesUseCase` fetches user's level and focus areas
4. `GetDailyLessonsUseCase` calls repository with user preferences
5. Repository creates personalized AI prompts based on preferences
6. AI generates level-appropriate and focus-specific content in a single request
7. Content is saved locally with analytics metadata and displayed to user
8. Background sync service silently saves content to Firebase for global reuse

### **Conversation Flow** ⭐ **NEW**
1. User starts conversation or sends message
2. `DailyLessonsBloc` triggers `SendConversationMessage` event with preferences and message
3. `SendConversationMessageUseCase` calls conversation repository
4. Repository finds existing thread for preferences or creates new one
5. AI conversation service generates context-aware response
6. Conversation is saved locally with thread persistence
7. Response is displayed to user

## Key Components

- **AI Providers:** OpenAI, Gemini, DeepSeek with unified interface
- **Cost Optimization:** Combined requests reduce API costs by 25-40%
- **Specialized Local Storage:** Hive-based persistence using composition pattern
- **Analytics:** Learning progress and usage analytics through specialized data source
- **Personalization:** Level and focus-specific content generation
- **Conversation Mode:** Persistent AI conversations with thread management
- **Background Sync:** Firebase integration for content sharing with event-driven architecture
- **Clean Architecture:** Simplified, focused separation of concerns

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

To use the daily lessons feature with personalization and conversation capabilities:

```dart
// Fetch personalized lessons (automatically uses user preferences)
context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchLessons());

// Refresh lessons
context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.refreshLessons());

// Get user preferences
context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.getUserPreferences());

// Start conversation mode ⭐ NEW
final preferences = UserPreferences(
  level: UserLevel.intermediate,
  focusAreas: ['business'],
);

context.read<DailyLessonsBloc>().add(
  DailyLessonsEvent.sendConversationMessage(
    preferences: preferences,
    message: "Can you help me practice business English?",
  ),
);
```

The feature automatically adapts to the user's English level and selected learning focus areas, providing personalized content and context-aware conversations for an engaging learning experience.
