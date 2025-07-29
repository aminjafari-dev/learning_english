# Vocabulary History Feature

## Description

The Vocabulary History feature allows users to view their complete history of vocabulary and phrases that have been generated through the daily lessons feature. It provides a comprehensive view of all learning requests made by the user, organized by request date, with detailed views showing the specific vocabulary and phrases generated for each request. The feature follows Clean Architecture principles and integrates seamlessly with the existing daily lessons data storage system. Now includes comprehensive metadata about each request including user context, AI provider details, costs, and prompts used.

## Architecture

The vocabulary history feature is structured according to Clean Architecture principles:

### **Domain Layer**
- `entities/` - Business objects:
  - `vocabulary_history_item.dart` - Represents a single vocabulary item in history (simplified)
  - `phrase_history_item.dart` - Represents a single phrase item in history (simplified)
  - `history_request.dart` - Represents a complete learning request with comprehensive metadata
- `repositories/` - Abstract repository interfaces:
  - `vocabulary_history_repository.dart` - Main repository interface for history operations
- `usecases/` - Business logic:
  - `get_history_requests_usecase.dart` - Fetches all history requests
  - `get_request_details_usecase.dart` - Fetches detailed vocabulary and phrases for a specific request

### **Data Layer**
- `datasources/` - Data sources:
  - `local/` - Local storage:
    - `vocabulary_history_local_data_source.dart` - Handles local storage operations for history data
- `models/` - Data models:
  - `vocabulary_history_model.dart` - Data model for vocabulary history items (simplified)
  - `phrase_history_model.dart` - Data model for phrase history items (simplified)
  - `history_request_model.dart` - Data model for complete history requests with comprehensive metadata
- `repositories/` - Repository implementations:
  - `vocabulary_history_repository_impl.dart` - Implements the repository interface

### **Presentation Layer**
- `bloc/` - State management:
  - `vocabulary_history_event.dart` - Events for vocabulary history operations
  - `vocabulary_history_state.dart` - States for vocabulary history operations
  - `vocabulary_history_bloc.dart` - BLoC for managing vocabulary history state
- `pages/` - Screen widgets:
  - `vocabulary_history_page.dart` - Main history list page
  - `request_detail_page.dart` - Detail page showing vocabularies and phrases for a specific request
- `widgets/` - Feature-specific widgets:
  - `history_request_card.dart` - Card widget for displaying history requests
  - `vocabulary_history_card.dart` - Card widget for displaying vocabulary items
  - `phrase_history_card.dart` - Card widget for displaying phrase items

## Use Cases

1. **Get History Requests Use Case**
   - **Description**: Retrieves all learning requests made by the user, grouped by request date and ID
   - **Data Flow**: Page -> Bloc -> UseCase -> Repository -> LocalDataSource

2. **Get Request Details Use Case**
   - **Description**: Fetches detailed vocabulary and phrases for a specific learning request
   - **Data Flow**: Page -> Bloc -> UseCase -> Repository -> LocalDataSource

## Data Flow

1. User navigates to the vocabulary history page
2. The page triggers a `LoadHistoryRequests` event
3. The BLoC processes the event and calls the `GetHistoryRequestsUseCase`
4. The use case calls the repository to fetch data from local storage
5. The repository queries the local data source (Hive) for all saved learning request data
6. Data is grouped by request ID and date, then returned to the BLoC
7. The BLoC emits a `HistoryRequestsLoaded` state with the grouped data
8. The page displays the history requests in a list format
9. When user taps on a request, navigation occurs to the detail page
10. The detail page loads specific vocabulary and phrases for that request using the same flow

## Key Components

- **Hive Local Storage**: Leverages existing Hive storage from daily lessons feature
- **BLoC State Management**: Uses flutter_bloc for reactive state management
- **Clean Architecture**: Strict separation of concerns across layers
- **Custom UI Components**: Uses GScaffold, GText, GButton, and GGap for consistent styling
- **Localization**: Supports both English and Persian languages
- **Theme Integration**: Follows the app's gold and brown color scheme
- **Comprehensive Metadata**: Each request includes user level, focus areas, AI provider details, costs, and prompts
- **Simplified Models**: Vocabulary and phrase models are simplified to avoid data duplication with parent request metadata 