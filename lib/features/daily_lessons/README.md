# Daily Lessons Feature

## Description

The Daily Lessons feature provides AI-generated vocabulary and phrases for English learning. It implements a cost-optimized approach using combined AI requests and includes comprehensive user-specific data storage with analytics capabilities. The feature follows Clean Architecture principles with feature-first organization and uses BLoC for state management.

## Architecture

### Domain Layer
- **entities/**: Pure Dart classes representing business objects
  - `vocabulary.dart`: Vocabulary entity with English and Persian translations
  - `phrase.dart`: Phrase entity with English and Persian translations
- **repositories/**: Abstract repository interfaces
  - `daily_lessons_repository.dart`: Interface for daily lessons operations with user-specific methods
- **usecases/**: Business logic operations
  - `get_daily_vocabularies_usecase.dart`: Fetches daily vocabularies
  - `get_daily_phrases_usecase.dart`: Fetches daily phrases
  - `get_daily_lessons_usecase.dart`: Fetches both vocabularies and phrases (cost-effective)
  - `refresh_daily_lessons_usecase.dart`: Refreshes all lesson content
  - `mark_vocabulary_as_used_usecase.dart`: Marks vocabulary as used by user
  - `mark_phrase_as_used_usecase.dart`: Marks phrase as used by user
  - `get_user_analytics_usecase.dart`: Gets user analytics and usage statistics

### Data Layer
- **datasources/**: Data source implementations
  - `ai_lessons_remote_data_source.dart`: Abstract interface for AI data sources
  - `daily_lessons_remote_data_source.dart`: Multi-model delegator for AI providers
  - `daily_lessons_local_data_source.dart`: Local storage for user-specific data
  - `openai_lessons_remote_data_source.dart`: OpenAI implementation
  - `gemini_lessons_remote_data_source.dart`: Google Gemini implementation
  - `deepseek_lessons_remote_data_source.dart`: DeepSeek implementation
  - `ai_provider_type.dart`: Enum for supported AI providers
- **models/**: Data models (DTOs) with user tracking and metadata
  - `vocabulary_model.dart`: Enhanced vocabulary model with user tracking, AI provider, tokens, and usage status
  - `phrase_model.dart`: Enhanced phrase model with user tracking, AI provider, tokens, and usage status
- **repositories/**: Repository implementations
  - `daily_lessons_repository_impl.dart`: Implementation with user-specific storage and retrieval logic

### Presentation Layer
- **bloc/**: State management
  - `daily_lessons_event.dart`: Events including user-specific operations
  - `daily_lessons_state.dart`: States including analytics and data management states
  - `daily_lessons_bloc.dart`: BLoC implementation with user-specific logic
- **pages/**: Screen widgets
  - `daily_lessons_page.dart`: Main daily lessons screen
- **widgets/**: Reusable widgets
  - Various UI components for displaying lessons

## Use Cases

1. **Get Daily Lessons**: Fetches both vocabularies and phrases in a single AI request (cost-effective)
   - Description: Retrieves 4 vocabularies and 2 phrases with Persian translations
   - Data Flow: Page → Bloc → UseCase → Repository → LocalDataSource (if available) → RemoteDataSource (if needed)

2. **Mark Content as Used**: Tracks user interaction with learning content
   - Description: Marks vocabulary or phrase as used to prevent duplicate suggestions
   - Data Flow: Page → Bloc → UseCase → Repository → LocalDataSource

3. **Get User Analytics**: Provides comprehensive usage statistics
   - Description: Returns analytics on learning progress, AI usage costs, and provider performance
   - Data Flow: Page → Bloc → UseCase → Repository → LocalDataSource

4. **Refresh Lessons**: Forces new content generation from AI
   - Description: Bypasses local cache and fetches fresh content from AI providers
   - Data Flow: Page → Bloc → UseCase → Repository → RemoteDataSource

## Data Flow

1. **User requests daily lessons**:
   - UI triggers `DailyLessonsEvent.fetchLessons()`
   - BLoC processes event and calls `GetDailyLessonsUseCase`
   - Repository checks local storage for unused content
   - If sufficient unused content exists, returns from local storage
   - If insufficient content, fetches from AI and saves to local storage
   - UI displays content and updates state

2. **User interacts with content**:
   - UI triggers `DailyLessonsEvent.markVocabularyAsUsed()` or `markPhraseAsUsed()`
   - BLoC processes event and calls respective use case
   - Repository updates usage status in local storage
   - Future requests will avoid suggesting the same content

3. **Analytics and monitoring**:
   - UI triggers `DailyLessonsEvent.getUserAnalytics()`
   - BLoC processes event and calls `GetUserAnalyticsUseCase`
   - Repository aggregates data from local storage
   - Returns comprehensive analytics including token usage, provider performance, and learning progress

## Key Components

- **Clean Architecture**: Strict separation of concerns with domain, data, and presentation layers
- **User-Specific Storage**: Local storage with SharedPreferences for each user's learning data
- **AI Provider Agnostic**: Support for multiple AI providers (OpenAI, Gemini, DeepSeek)
- **Cost Optimization**: Combined requests reduce API costs by 25-40%
- **Analytics**: Comprehensive tracking of user progress and AI usage costs
- **BLoC State Management**: Reactive state management with freezed for type safety
- **Dependency Injection**: Modular DI setup with GetIt for testability

## Cost Optimization Strategy

The feature implements a sophisticated cost optimization strategy:

1. **Combined Requests**: Single AI request for both vocabularies and phrases (200-250 tokens vs 300-400 tokens)
2. **Local Caching**: Stores unused content locally to avoid repeated AI requests
3. **Usage Tracking**: Prevents duplicate content suggestions to maximize local cache efficiency
4. **Provider Analytics**: Tracks performance and costs by AI provider for optimization

## Future Enhancements

1. **Content Reuse**: Suggest previously generated content to other users
2. **Advanced Analytics**: Machine learning insights for personalized learning paths
3. **Offline Support**: Enhanced offline capabilities with pre-downloaded content
4. **Multi-language Support**: Extend beyond English-Persian translations
