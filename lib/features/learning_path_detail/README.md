# Learning Path Detail Feature

## Description

The Learning Path Detail feature provides a detailed view of individual learning paths, allowing users to track their progress through courses, complete lessons, and manage their learning journey. This feature is separated from the main Learning Paths feature to maintain clean architecture and modularity.

## Architecture

### Domain Layer
- **entities/**: Re-exports entities from the learning_paths feature to maintain consistency
  - `learning_path.dart` - Main learning path entity
  - `sub_category.dart` - Sub-category entity for specialized learning areas
  - `course.dart` - Individual course entity within a learning path
- **repositories/**: Repository interfaces
  - `learning_path_detail_repository.dart` - Contract for learning path detail operations
- **usecases/**: Business logic use cases
  - `get_learning_path_by_id_usecase.dart` - Retrieves a specific learning path
  - `complete_course_usecase.dart` - Handles course completion and progression
  - `delete_learning_path_by_id_usecase.dart` - Removes a learning path
  - `get_progress_statistics_usecase.dart` - Gets progress statistics

### Data Layer
- **datasources/local/**: Local data source using Hive storage
  - `learning_path_detail_local_data_source.dart` - Handles local storage operations
- **repositories/**: Repository implementations
  - `learning_path_detail_repository_impl.dart` - Implements the repository contract
- **models/**: Re-exports models from the learning_paths feature
  - `learning_path_model.dart` - Data model for learning paths
  - `sub_category_model.dart` - Data model for sub-categories
  - `course_model.dart` - Data model for courses

### Presentation Layer
- **bloc/**: State management
  - `learning_path_detail_bloc.dart` - Main BLoC for state management
  - `learning_path_detail_event.dart` - Events for user actions
  - `learning_path_detail_state.dart` - States for UI rendering
- **pages/**: Screen implementations
  - `learning_path_detail_page.dart` - Main detail page showing path info and course grid
- **widgets/**: Reusable UI components
  - `course_grid.dart` - 4x5 grid displaying all 20 courses
  - `course_card.dart` - Individual course cards with status indicators

## Use Cases

1. **View Learning Path Details**: Display comprehensive information about a specific learning path
2. **Track Progress**: Show completion status and progress percentage
3. **Course Management**: Handle course completion and unlocking of next courses
4. **Path Deletion**: Allow users to remove learning paths they no longer need

## Data Flow

1. **Page Load**: Page -> Bloc -> GetLearningPathByIdUseCase -> Repository -> DataSource
2. **Course Completion**: User Action -> Bloc -> CompleteCourseUseCase -> Repository -> DataSource
3. **Path Deletion**: User Action -> Bloc -> DeleteLearningPathByIdUseCase -> Repository -> DataSource

## Key Components

- **Clean Architecture**: Follows the established pattern with clear separation of concerns
- **State Management**: Uses BLoC pattern with freezed for immutable states
- **Local Storage**: Hive database for persistent data storage
- **Dependency Injection**: GetIt for managing dependencies
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **Progress Tracking**: Real-time progress updates and course unlocking logic

## Integration

This feature integrates seamlessly with the main Learning Paths feature:
- Uses the same data models and entities to ensure consistency
- Shares the same Hive storage for data persistence
- Maintains the same UI/UX patterns and theming
- Follows the same architectural principles

## Dependencies

- `flutter_bloc` - State management
- `freezed` - Immutable data classes
- `hive_flutter` - Local storage
- `get_it` - Dependency injection
- `dartz` - Functional programming utilities
