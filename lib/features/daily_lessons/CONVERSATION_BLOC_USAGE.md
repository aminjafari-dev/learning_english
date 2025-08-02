# Conversation Mode Usage in Daily Lessons Bloc

## Overview

The conversation mode functionality has been integrated into the existing `DailyLessonsBloc` following clean architecture principles. This allows for persistent conversations based on user preferences (level + focus areas) without creating separate controllers.

## Bloc Events

### 1. Initialize Conversation
```dart
// Initialize conversation with user preferences
final preferences = UserPreferences(
  level: UserLevel.intermediate,
  focusAreas: ['business'],
);

context.read<DailyLessonsBloc>().add(
  DailyLessonsEvent.initializeConversation(preferences: preferences),
);
```

### 2. Send Message
```dart
// Send a message in conversation mode
context.read<DailyLessonsBloc>().add(
  DailyLessonsEvent.sendConversationMessage(
    preferences: preferences,
    message: "Hello, how are you?",
  ),
);
```

### 3. Load User Threads
```dart
// Load all conversation threads for the current user
context.read<DailyLessonsBloc>().add(
  const DailyLessonsEvent.loadUserConversationThreads(),
);
```

### 4. Switch Thread
```dart
// Switch to a different conversation thread
context.read<DailyLessonsBloc>().add(
  DailyLessonsEvent.switchToConversationThread(thread: selectedThread),
);
```

### 5. Clear Threads
```dart
// Clear all conversation threads for the current user
context.read<DailyLessonsBloc>().add(
  const DailyLessonsEvent.clearUserConversationThreads(),
);
```

## Bloc States

### Conversation State
```dart
// Initial state
ConversationState.initial()

// Loading state
ConversationState.loading()

// Loaded state with conversation data
ConversationState.loaded({
  currentThread: thread,
  messages: messages,
  userThreads: threads,
})

// Error state
ConversationState.error("Error message")
```

## UI Implementation Example

```dart
class ConversationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyLessonsBloc, DailyLessonsState>(
      builder: (context, state) {
        return state.conversation.when(
          initial: () => _buildInitialState(),
          loading: () => _buildLoadingState(),
          loaded: (currentThread, messages, userThreads) => _buildLoadedState(
            currentThread,
            messages,
            userThreads,
          ),
          error: (message) => _buildErrorState(message),
        );
      },
    );
  }

  Widget _buildLoadedState(
    ConversationThreadModel? currentThread,
    List<ConversationMessageModel> messages,
    List<ConversationThreadModel> userThreads,
  ) {
    return Column(
      children: [
        // Thread selection
        if (userThreads.isNotEmpty)
          _buildThreadSelector(userThreads),
        
        // Messages list
        Expanded(
          child: _buildMessagesList(messages),
        ),
        
        // Input area
        _buildInputArea(),
      ],
    );
  }

  Widget _buildInputArea() {
    final controller = TextEditingController();
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              final message = controller.text.trim();
              if (message.isNotEmpty) {
                // Get current preferences and send message
                final preferences = UserPreferences(
                  level: UserLevel.intermediate,
                  focusAreas: ['business'],
                );
                
                context.read<DailyLessonsBloc>().add(
                  DailyLessonsEvent.sendConversationMessage(
                    preferences: preferences,
                    message: message,
                  ),
                );
                controller.clear();
              }
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
```

## Thread Management

### Thread Identification
Each thread is identified by a unique combination of:
- User level (beginner, intermediate, etc.)
- Focus areas (business, travel, casual, etc.)

### Thread Persistence
- Threads are stored in Hive database
- Persist across app sessions
- Automatic retrieval when same preferences are selected

### Thread Switching
```dart
// When user selects different preferences
final newPreferences = UserPreferences(
  level: UserLevel.advanced,
  focusAreas: ['travel'],
);

// This will create a new thread or load existing one
context.read<DailyLessonsBloc>().add(
  DailyLessonsEvent.initializeConversation(preferences: newPreferences),
);
```

## Integration with Existing Features

### Combined with Daily Lessons
```dart
// User can switch between daily lessons and conversation mode
// Both use the same bloc and state management

// Load daily lessons
context.read<DailyLessonsBloc>().add(
  const DailyLessonsEvent.fetchLessons(),
);

// Switch to conversation mode
context.read<DailyLessonsBloc>().add(
  DailyLessonsEvent.initializeConversation(preferences: preferences),
);
```

### User Preferences Integration
```dart
// Get user preferences for conversation
context.read<DailyLessonsBloc>().add(
  const DailyLessonsEvent.getUserPreferences(),
);

// Use preferences for conversation
final preferences = state.userPreferences;
if (preferences != null) {
  context.read<DailyLessonsBloc>().add(
    DailyLessonsEvent.initializeConversation(preferences: preferences),
  );
}
```

## Error Handling

### Network Errors
```dart
// Handle network errors gracefully
state.conversation.when(
  error: (message) => _showErrorDialog(message),
  // ... other states
);
```

### Data Validation
```dart
// Validate message before sending
if (message.trim().isNotEmpty) {
  context.read<DailyLessonsBloc>().add(
    DailyLessonsEvent.sendConversationMessage(
      preferences: preferences,
      message: message.trim(),
    ),
  );
}
```

## Best Practices

### 1. State Management
- Always check if emit is done before emitting new states
- Handle loading states properly
- Provide clear error messages

### 2. Thread Management
- Initialize conversation before sending messages
- Load user threads when needed
- Clear threads when user wants to reset

### 3. UI Updates
- Use BlocBuilder for reactive UI updates
- Handle all conversation states (initial, loading, loaded, error)
- Provide loading indicators during operations

### 4. Performance
- Avoid unnecessary bloc events
- Cache conversation data when possible
- Handle large message lists efficiently

## Testing

### Unit Tests
```dart
// Test conversation events
blocTest<DailyLessonsBloc, DailyLessonsState>(
  'emits conversation loaded when initialize conversation succeeds',
  build: () => DailyLessonsBloc(...),
  act: (bloc) => bloc.add(
    DailyLessonsEvent.initializeConversation(preferences: preferences),
  ),
  expect: () => [
    state.copyWith(conversation: ConversationState.loading()),
    state.copyWith(
      conversation: ConversationState.loaded(...),
    ),
  ],
);
```

### Integration Tests
```dart
// Test complete conversation flow
testWidgets('complete conversation flow', (tester) async {
  // Setup
  await tester.pumpWidget(MyApp());
  
  // Initialize conversation
  context.read<DailyLessonsBloc>().add(
    DailyLessonsEvent.initializeConversation(preferences: preferences),
  );
  await tester.pump();
  
  // Send message
  context.read<DailyLessonsBloc>().add(
    DailyLessonsEvent.sendConversationMessage(
      preferences: preferences,
      message: "Hello",
    ),
  );
  await tester.pump();
  
  // Verify state changes
  expect(find.text("Hello"), findsOneWidget);
});
```

## Conclusion

The conversation mode functionality is now fully integrated into the existing `DailyLessonsBloc` following clean architecture principles. This provides:

✅ **Unified State Management** - All features use the same bloc
✅ **Clean Architecture** - Proper separation of concerns
✅ **Persistent Conversations** - Thread-based conversation management
✅ **Error Handling** - Comprehensive error handling and user feedback
✅ **Scalable** - Easy to extend with new features
✅ **Testable** - Well-structured for unit and integration testing

The implementation maintains the existing bloc pattern while adding powerful conversation capabilities that persist across app sessions. 