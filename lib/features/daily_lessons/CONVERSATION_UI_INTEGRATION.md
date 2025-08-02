# Conversation UI Integration Guide

## Overview

The conversation functionality has been integrated into the existing UI structure without changing the current design. You can now use conversation events instead of daily lessons events in your existing pages and widgets.

## Integration Options

### Option 1: Replace Daily Lessons with Conversation

Instead of using `DailyLessonsEvent.fetchLessons()`, use conversation events:

```dart
// OLD: Fetch daily lessons
context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchLessons());

// NEW: Initialize conversation
final preferences = UserPreferences(
  level: UserLevel.intermediate,
  focusAreas: ['business'],
);

context.read<DailyLessonsBloc>().add(
  DailyLessonsEvent.initializeConversation(preferences: preferences),
);
```

### Option 2: Add Conversation Mode to Existing Page

Add conversation functionality to your existing `DailyLessonsPage`:

```dart
// In your existing daily_lessons_page.dart
class DailyLessonsPage extends StatelessWidget {
  const DailyLessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = getIt<DailyLessonsBloc>();

    return GScaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: const DailyLessonsHeader(),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 24),
        ),
        actions: [
          // Add conversation mode button
          IconButton(
            onPressed: () => _showConversationMode(context, bloc),
            icon: Icon(Icons.chat, size: 24),
            tooltip: 'Conversation Mode',
          ),
        ],
        centerTitle: true,
      ),
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<DailyLessonsBloc, DailyLessonsState>(
          bloc: bloc,
          builder: (context, state) {
            // Check if conversation mode is active
            if (_isConversationModeActive(state)) {
              return ConversationContent(
                state: state,
                messageController: TextEditingController(),
                onSendMessage: () => _sendMessage(context, bloc),
                preferences: _getCurrentPreferences(),
              );
            }
            
            // Show regular daily lessons content
            return DailyLessonsContent(state: state);
          },
        ),
      ),
    );
  }

  void _showConversationMode(BuildContext context, DailyLessonsBloc bloc) {
    final preferences = UserPreferences(
      level: UserLevel.intermediate,
      focusAreas: ['business'],
    );
    
    bloc.add(DailyLessonsEvent.initializeConversation(preferences: preferences));
  }

  bool _isConversationModeActive(DailyLessonsState state) {
    return state.conversation is ConversationLoaded;
  }

  UserPreferences _getCurrentPreferences() {
    return UserPreferences(
      level: UserLevel.intermediate,
      focusAreas: ['business'],
    );
  }

  void _sendMessage(BuildContext context, DailyLessonsBloc bloc) {
    // Implementation for sending message
  }
}
```

### Option 3: Use Dedicated Conversation Page

Use the new `ConversationPage` for dedicated conversation functionality:

```dart
// Navigate to conversation page
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => ConversationPage(
      initialPreferences: UserPreferences(
        level: UserLevel.intermediate,
        focusAreas: ['business'],
      ),
    ),
  ),
);
```

## State Management

### Conversation States

The conversation functionality uses these states:

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

### Accessing Conversation Data

```dart
BlocBuilder<DailyLessonsBloc, DailyLessonsState>(
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
```

## Event Integration

### Available Conversation Events

```dart
// Initialize conversation
DailyLessonsEvent.initializeConversation(preferences: preferences)

// Send message
DailyLessonsEvent.sendConversationMessage(
  preferences: preferences,
  message: "Hello",
)

// Load user threads
DailyLessonsEvent.loadUserConversationThreads()

// Switch thread
DailyLessonsEvent.switchToConversationThread(thread: selectedThread)

// Clear threads
DailyLessonsEvent.clearUserConversationThreads()
```

### Example: Adding Conversation Button

```dart
// Add this to your existing widget
ElevatedButton(
  onPressed: () {
    final preferences = UserPreferences(
      level: UserLevel.intermediate,
      focusAreas: ['business'],
    );
    
    context.read<DailyLessonsBloc>().add(
      DailyLessonsEvent.initializeConversation(preferences: preferences),
    );
  },
  child: Text('Start Conversation'),
),
```

## UI Components

### ConversationContent Widget

The `ConversationContent` widget provides:

- Preferences display
- Messages list with user/AI distinction
- Input area for sending messages
- Thread selector for multiple conversations
- Loading and error states

### Usage in Existing Widgets

```dart
// In your existing widget
ConversationContent(
  state: state,
  messageController: _messageController,
  onSendMessage: _sendMessage,
  preferences: _preferences,
)
```

## Thread Management

### Thread Identification

Each conversation thread is identified by:
- User level (beginner, intermediate, etc.)
- Focus areas (business, travel, casual, etc.)

### Thread Persistence

- Threads persist across app sessions
- Automatic retrieval when same preferences are selected
- New thread creation for different preferences

### Thread Switching

```dart
// Load all user threads
context.read<DailyLessonsBloc>().add(
  const DailyLessonsEvent.loadUserConversationThreads(),
);

// Switch to specific thread
context.read<DailyLessonsBloc>().add(
  DailyLessonsEvent.switchToConversationThread(thread: selectedThread),
);
```

## Integration Examples

### Example 1: Add to Existing Page

```dart
// In your existing daily_lessons_page.dart
class DailyLessonsPage extends StatefulWidget {
  @override
  State<DailyLessonsPage> createState() => _DailyLessonsPageState();
}

class _DailyLessonsPageState extends State<DailyLessonsPage> {
  bool _isConversationMode = false;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc = getIt<DailyLessonsBloc>();
    
    if (!_isConversationMode) {
      bloc.add(const DailyLessonsEvent.fetchLessons());
    }

    return GScaffold(
      appBar: AppBar(
        title: Text(_isConversationMode ? 'Conversation' : 'Daily Lessons'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isConversationMode = !_isConversationMode;
              });
              
              if (_isConversationMode) {
                final preferences = UserPreferences(
                  level: UserLevel.intermediate,
                  focusAreas: ['business'],
                );
                bloc.add(DailyLessonsEvent.initializeConversation(
                  preferences: preferences,
                ));
              } else {
                bloc.add(const DailyLessonsEvent.fetchLessons());
              }
            },
            icon: Icon(_isConversationMode ? Icons.book : Icons.chat),
          ),
        ],
      ),
      body: BlocBuilder<DailyLessonsBloc, DailyLessonsState>(
        bloc: bloc,
        builder: (context, state) {
          if (_isConversationMode) {
            return ConversationContent(
              state: state,
              messageController: _messageController,
              onSendMessage: _sendMessage,
              preferences: UserPreferences(
                level: UserLevel.intermediate,
                focusAreas: ['business'],
              ),
            );
          }
          
          return DailyLessonsContent(state: state);
        },
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<DailyLessonsBloc>().add(
        DailyLessonsEvent.sendConversationMessage(
          preferences: UserPreferences(
            level: UserLevel.intermediate,
            focusAreas: ['business'],
          ),
          message: message,
        ),
      );
      _messageController.clear();
    }
  }
}
```

### Example 2: Separate Conversation Page

```dart
// Navigate to conversation page
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => ConversationPage(
      initialPreferences: UserPreferences(
        level: UserLevel.intermediate,
        focusAreas: ['business'],
      ),
    ),
  ),
);
```

## Best Practices

### 1. State Management
- Always check conversation state before accessing data
- Handle loading and error states properly
- Use the same bloc for both daily lessons and conversation

### 2. UI Integration
- Keep existing UI structure unchanged
- Add conversation functionality as an additional feature
- Use consistent styling with existing components

### 3. Thread Management
- Initialize conversation before sending messages
- Load user threads when needed
- Clear threads when user wants to reset

### 4. Error Handling
- Handle network errors gracefully
- Provide clear error messages
- Allow users to retry failed operations

## Conclusion

The conversation functionality is now fully integrated into your existing UI structure. You can:

✅ **Use existing bloc** - No need for separate state management
✅ **Keep current UI** - No changes to existing design
✅ **Add conversation mode** - Seamless integration
✅ **Persistent threads** - Thread-based conversation management
✅ **Clean architecture** - Proper separation of concerns

Choose the integration option that best fits your needs:
- **Option 1**: Replace daily lessons with conversation
- **Option 2**: Add conversation mode to existing page
- **Option 3**: Use dedicated conversation page

The implementation maintains your existing UI while adding powerful conversation capabilities that persist across app sessions. 