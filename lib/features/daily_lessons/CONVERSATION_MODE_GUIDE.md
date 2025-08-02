# Conversation Mode System Guide

## Overview

The conversation mode system allows users to have persistent conversations with the AI based on their learning preferences (level + focus areas). Each unique combination of level and focus areas creates a separate conversation thread that persists across app sessions.

## Key Features

### 1. Thread Management
- **Unique Threads**: Each combination of level + focus areas gets its own conversation thread
- **Persistence**: Threads are stored in Hive database and persist across app sessions
- **Automatic Retrieval**: When user selects the same preferences again, the existing thread is loaded
- **New Thread Creation**: When user selects different preferences, a new thread is created

### 2. Conversation Flow
```
User selects preferences (Intermediate + Business)
    ↓
System checks for existing thread
    ↓
If thread exists → Load existing conversation
If no thread → Create new thread
    ↓
User sends message
    ↓
AI responds with context-aware response
    ↓
Conversation continues in same thread
```

## Architecture

### Domain Layer
- **Use Cases**:
  - `GetConversationThreadUseCase`: Gets or creates thread for preferences
  - `SendConversationMessageUseCase`: Sends message and gets AI response
  - `GetUserConversationThreadsUseCase`: Gets all user threads
  - `ClearUserConversationThreadsUseCase`: Clears all user threads

- **Repository Interface**: `DailyLessonsRepository` with conversation methods

### Data Layer
- **Models**:
  - `ConversationThreadModel`: Represents a conversation thread
  - `ConversationMessageModel`: Represents individual messages

- **Services**:
  - `GeminiConversationService`: Handles AI communication
  - `DailyLessonsLocalDataSource`: Handles thread persistence

### Presentation Layer
- **Controller**: `ConversationController` manages conversation state
- **Example**: `ConversationModeExample` shows usage

## Usage Examples

### 1. Send Conversation Message
```dart
final bloc = context.read<DailyLessonsBloc>();
final preferences = UserPreferences(
  level: UserLevel.intermediate,
  focusAreas: ['business'],
);

bloc.add(DailyLessonsEvent.sendConversationMessage(
  preferences: preferences,
  message: "Hello, how are you?",
));
```

### 2. Get User Preferences
```dart
bloc.add(const DailyLessonsEvent.getUserPreferences());
```

### 3. Access Conversation State
```dart
BlocBuilder<DailyLessonsBloc, DailyLessonsState>(
  builder: (context, state) {
    return state.conversation.when(
      initial: () => _buildInitialState(),
      loading: () => _buildLoadingState(),
      loaded: (currentThread, messages, userThreads) => _buildConversation(
        currentThread, messages, userThreads,
      ),
      error: (message) => _buildErrorState(message),
    );
  },
);
```

### 4. Switch Thread (Automatic)
```dart
// Thread switching is automatic - just send a message with different preferences
final newPreferences = UserPreferences(
  level: UserLevel.advanced,
  focusAreas: ['travel'],
);

bloc.add(DailyLessonsEvent.sendConversationMessage(
  preferences: newPreferences,
  message: "Let's practice travel English",
));
```

## Thread Identification

Threads are identified by a unique hash generated from user preferences:

```dart
// Example: intermediate_business_travel
final hash = '${level.name}_${sortedFocusAreas.join('_')}';
```

This ensures:
- Same preferences = Same thread
- Different preferences = Different thread
- Threads are easily searchable and retrievable

## Data Persistence

### Hive Storage
- Threads are stored in Hive database
- Each thread contains:
  - User ID
  - Thread ID
  - Messages (user + AI)
  - Preferences (level + focus areas)
  - Timestamps

### Message Structure
```dart
class ConversationMessageModel {
  final String role; // 'user' or 'model'
  final String content;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
}
```

## AI Integration

### Context-Aware Responses
The AI receives:
- User's learning history
- Previous conversation messages
- Current preferences (level + focus areas)
- Used vocabularies and phrases

### Response Generation
```dart
// AI gets context like:
"User is intermediate level, focusing on business English.
Previous conversation: [message history]
Used vocabularies: [list of used words]
Current message: [user input]"
```

## Error Handling

### Network Errors
- Retry mechanisms for failed requests
- Graceful degradation when AI is unavailable
- User-friendly error messages

### Data Errors
- Automatic thread recovery
- Fallback to default preferences
- Data validation and sanitization

## Performance Considerations

### Memory Management
- Messages are loaded on-demand
- Old threads can be archived
- Efficient thread searching

### Network Optimization
- Batch message processing
- Cached responses
- Minimal API calls

## Testing

### Unit Tests
- Use case testing
- Repository testing
- Controller testing

### Integration Tests
- End-to-end conversation flow
- Thread persistence testing
- AI integration testing

## Future Enhancements

### Planned Features
- Thread archiving
- Message search
- Conversation analytics
- Multi-language support
- Voice messages

### Scalability
- Pagination for large conversations
- Background sync
- Offline support
- Cloud backup

## Best Practices

### For Developers
1. Always check for existing threads before creating new ones
2. Handle loading states properly
3. Provide clear error messages
4. Test with different preference combinations
5. Monitor conversation quality and user feedback

### For Users
1. Use consistent preferences for related conversations
2. Clear old threads when starting fresh
3. Provide context in messages for better AI responses
4. Use the thread switching feature to manage multiple topics

## Troubleshooting

### Common Issues
1. **Thread not found**: Check preference matching logic
2. **Messages not saving**: Verify Hive database initialization
3. **AI not responding**: Check network connectivity and API keys
4. **Performance issues**: Monitor message count and thread size

### Debug Tools
- Thread inspection utilities
- Message history viewer
- Preference validation tools
- Performance monitoring

## Conclusion

The conversation mode system provides a robust, scalable solution for persistent AI conversations based on user learning preferences. It ensures context continuity while maintaining clean separation between different learning topics and levels. 