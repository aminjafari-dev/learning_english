# Daily Lessons Feature

## Description

The Daily Lessons feature provides AI-generated vocabulary and phrases for English learning with comprehensive user-specific data management. It implements a cost-optimized approach using combined AI requests and includes advanced local storage with Hive, user analytics, and multi-provider AI support. The feature follows Clean Architecture principles with feature-first organization and uses BLoC for state management.

## Architecture

### Domain Layer
- **entities/**: Pure Dart classes representing business objects
  - `vocabulary.dart`: Vocabulary entity with English and Persian translations
  - `phrase.dart`: Phrase entity with English and Persian translations
  - `ai_usage_metadata.dart`: Metadata for tracking AI usage and costs
- **repositories/**: Abstract repository interfaces
  - `daily_lessons_repository.dart`: Interface for daily lessons operations with user-specific methods and analytics
- **usecases/**: Business logic operations
  - `get_daily_vocabularies_usecase.dart`: Fetches daily vocabularies (deprecated - use getDailyLessons)
  - `get_daily_phrases_usecase.dart`: Fetches daily phrases (deprecated - use getDailyLessons)
  - `get_daily_lessons_usecase.dart`: Fetches both vocabularies and phrases (cost-effective)
  - `refresh_daily_lessons_usecase.dart`: Refreshes all lesson content
  - `mark_vocabulary_as_used_usecase.dart`: Marks vocabulary as used by user
  - `mark_phrase_as_used_usecase.dart`: Marks phrase as used by user
  - `get_user_analytics_usecase.dart`: Gets user analytics and usage statistics
  - `clear_user_data_usecase.dart`: Clears all user data for reset functionality

### Data Layer
- **datasources/**: Data source implementations
  - `ai_provider_type.dart`: Enum for supported AI providers (OpenAI, Gemini, DeepSeek)
  - `remote/`: Remote data sources for AI providers
    - `ai_lessons_remote_data_source.dart`: Abstract interface for AI data sources
    - `daily_lessons_remote_data_source.dart`: Multi-model delegator for AI providers
    - `openai_lessons_remote_data_source.dart`: OpenAI implementation
    - `gemini_lessons_remote_data_source.dart`: Google Gemini implementation
    - `deepseek_lessons_remote_data_source.dart`: DeepSeek implementation
  - `local/`: Local storage using Hive
    - `daily_lessons_local_data_source.dart`: Hive-based local storage with user-specific data management
- **models/**: Data models (DTOs) with comprehensive metadata tracking
  - `vocabulary_model.dart`: Enhanced vocabulary model with Hive support, user tracking, AI provider, tokens, usage status, and timestamps
  - `phrase_model.dart`: Enhanced phrase model with Hive support, user tracking, AI provider, tokens, usage status, and timestamps
- **repositories/**: Repository implementations
  - `daily_lessons_repository_impl.dart`: Implementation with user-specific storage, retrieval logic, and analytics

### Presentation Layer
- **bloc/**: State management with comprehensive user operations
  - `daily_lessons_event.dart`: Events including user-specific operations, analytics, and data management
  - `daily_lessons_state.dart`: States including analytics and data management states with freezed
  - `daily_lessons_bloc.dart`: BLoC implementation with user-specific logic and analytics
- **pages/**: Screen widgets
  - `daily_lessons_page.dart`: Main daily lessons screen
- **widgets/**: Reusable widgets
  - Various UI components for displaying lessons and analytics

## Use Cases

1. **Get Daily Lessons**: Fetches both vocabularies and phrases in a single AI request (cost-effective)
   - Description: Retrieves 4 vocabularies and 2 phrases with Persian translations, automatically saves to local storage
   - Data Flow: Page → Bloc → UseCase → Repository → LocalDataSource (check unused) → RemoteDataSource (if needed) → LocalDataSource (save)

2. **Mark Content as Used**: Tracks user interaction with learning content
   - Description: Marks vocabulary or phrase as used to prevent duplicate suggestions and track learning progress
   - Data Flow: Page → Bloc → UseCase → Repository → LocalDataSource (update usage status)

3. **Get User Analytics**: Provides comprehensive usage statistics and cost analysis
   - Description: Returns detailed analytics on learning progress, AI usage costs, provider performance, and token consumption
   - Data Flow: Page → Bloc → UseCase → Repository → LocalDataSource (aggregate data)

4. **Clear User Data**: Resets user's learning progress and stored content
   - Description: Clears all locally stored vocabularies and phrases for the current user
   - Data Flow: Page → Bloc → UseCase → Repository → LocalDataSource (clear all data)

5. **Get Content by Provider**: Analyzes performance and costs by AI provider
   - Description: Retrieves vocabulary and phrase data filtered by specific AI provider for analytics
   - Data Flow: Page → Bloc → UseCase → Repository → LocalDataSource (filter by provider)

## Data Flow

1. **User requests daily lessons**:
   - UI triggers `DailyLessonsEvent.fetchLessons()`
   - BLoC processes event and calls `GetDailyLessonsUseCase`
   - Repository checks local storage for unused content using `getUnusedVocabularies()` and `getUnusedPhrases()`
   - If sufficient unused content exists (4+ vocabularies, 2+ phrases), returns from local storage
   - If insufficient content, fetches from AI and saves to local storage with metadata
   - All AI-fetched content is automatically marked as used since user will definitely read it
   - UI displays content and updates state

2. **User interacts with content**:
   - UI triggers `DailyLessonsEvent.markVocabularyAsUsed()` or `markPhraseAsUsed()`
   - BLoC processes event and calls respective use case
   - Repository updates usage status in local storage using `markVocabularyAsUsed()` or `markPhraseAsUsed()`
   - Future requests will avoid suggesting the same content

3. **Analytics and monitoring**:
   - UI triggers `DailyLessonsEvent.getUserAnalytics()`
   - BLoC processes event and calls `GetUserAnalyticsUseCase`
   - Repository aggregates data from local storage using `getUserAnalytics()`
   - Returns comprehensive analytics including token usage, provider performance, and learning progress

4. **Data management**:
   - UI triggers `DailyLessonsEvent.clearUserData()`
   - BLoC processes event and calls `ClearUserDataUseCase`
   - Repository clears all data using `clearUserData()`
   - User's learning progress is reset

## Key Components

- **Clean Architecture**: Strict separation of concerns with domain, data, and presentation layers
- **Hive Local Storage**: Fast, type-safe local storage with user-specific data management
- **Multi-AI Provider Support**: Support for OpenAI, Google Gemini, and DeepSeek with provider-specific analytics
- **Cost Optimization**: Combined requests reduce API costs by 25-40% compared to separate requests
- **User Analytics**: Comprehensive tracking of learning progress, AI usage costs, and provider performance
- **Usage Tracking**: Prevents duplicate content suggestions and tracks user engagement
- **BLoC State Management**: Reactive state management with freezed for type safety
- **Dependency Injection**: Modular DI setup with GetIt for testability
- **Metadata Tracking**: Complete tracking of AI usage including tokens, providers, and request IDs

## Enhanced Local Storage Features

The feature now includes sophisticated local storage capabilities:

1. **Hive Integration**: Type-safe, fast local storage with automatic serialization
2. **User-Specific Data**: All content is stored per user with comprehensive metadata
3. **Usage Tracking**: Tracks which content has been used to avoid duplicates
4. **Provider Analytics**: Stores AI provider information for cost and performance analysis
5. **Token Tracking**: Records token usage for cost optimization
6. **Timestamp Management**: Tracks when content was created and used
7. **Data Persistence**: Survives app restarts and provides offline access to previously fetched content

## Cost Optimization Strategy

The feature implements a sophisticated cost optimization strategy:

1. **Combined Requests**: Single AI request for both vocabularies and phrases (200-250 tokens vs 300-400 tokens)
2. **Local Caching**: Stores unused content locally to avoid repeated AI requests
3. **Usage Tracking**: Prevents duplicate content suggestions to maximize local cache efficiency
4. **Provider Analytics**: Tracks performance and costs by AI provider for optimization
5. **Automatic Usage Marking**: All AI-fetched content is automatically marked as used since user will definitely read it
6. **Token Estimation**: Rough token estimation for cost tracking and optimization

## Analytics Capabilities

The feature provides comprehensive analytics:

1. **Learning Progress**: Tracks used vs unused content
2. **Cost Analysis**: Token usage by provider and total costs
3. **Provider Performance**: Success rates and costs by AI provider
4. **Content Distribution**: Breakdown of vocabularies and phrases by provider
5. **Usage Patterns**: When and how often content is used

## Future Enhancements

1. **Content Reuse**: Suggest previously generated content to other users
2. **Advanced Analytics**: Machine learning insights for personalized learning paths
3. **Offline Support**: Enhanced offline capabilities with pre-downloaded content
4. **Multi-language Support**: Extend beyond English-Persian translations
5. **Personalized Recommendations**: AI-driven content suggestions based on user progress
6. **Social Features**: Share learning progress and achievements
7. **Gamification**: Points, badges, and learning streaks
