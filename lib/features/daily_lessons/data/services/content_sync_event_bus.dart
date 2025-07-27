// content_sync_event_bus.dart
// Event bus for communication between main repository and background content sync service.
// This provides a decoupled way for the repository to trigger background operations
// without directly depending on Firebase or background service implementation.
//
// Usage:
//   ContentSyncEventBus.instance.notifyContentGenerated(vocabularies, phrases, context, userId);
//   ContentSyncEventBus.instance.notifyContentUsed(vocabularyIds, phraseIds);

import 'package:learning_english/features/daily_lessons/data/models/vocabulary_model.dart';
import 'package:learning_english/features/daily_lessons/data/models/phrase_model.dart';
import 'package:learning_english/features/daily_lessons/data/datasources/remote/firebase_lessons_remote_data_source.dart';
import 'package:learning_english/features/level_selection/domain/entities/user_profile.dart';

/// Event types for content synchronization
enum ContentSyncEventType {
  contentGenerated,
  contentUsed,
  userProgressUpdated,
  checkExistingContent,
}

/// Event data for content synchronization
class ContentSyncEventData {
  final ContentSyncEventType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  ContentSyncEventData({
    required this.type,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Event bus for content synchronization operations
/// This provides a singleton pattern for global event communication
class ContentSyncEventBus {
  static final ContentSyncEventBus _instance = ContentSyncEventBus._internal();
  factory ContentSyncEventBus() => _instance;
  ContentSyncEventBus._internal();

  /// Singleton instance of the event bus
  static ContentSyncEventBus get instance => _instance;

  final List<Function(ContentSyncEventData)> _listeners = [];
  bool _isEnabled = false;

  /// Enables the event bus for operation
  /// This should be called when the background service is ready
  void enable() {
    _isEnabled = true;
  }

  /// Disables the event bus
  /// This prevents events from being processed
  void disable() {
    _isEnabled = false;
  }

  /// Adds a listener for content sync events
  /// The listener will be called whenever an event is emitted
  ///
  /// Parameters:
  /// - listener: Function to call when events are emitted
  void addListener(Function(ContentSyncEventData) listener) {
    _listeners.add(listener);
  }

  /// Removes a listener from the event bus
  ///
  /// Parameters:
  /// - listener: Function to remove from listeners
  void removeListener(Function(ContentSyncEventData) listener) {
    _listeners.remove(listener);
  }

  /// Notifies that new content has been generated
  /// This triggers background sync operations without affecting user experience
  ///
  /// Parameters:
  /// - vocabularies: List of newly generated vocabularies
  /// - phrases: List of newly generated phrases
  /// - context: Learning context (level, focus area, difficulty)
  /// - userId: ID of the user who generated the content
  void notifyContentGenerated({
    required List<VocabularyModel> vocabularies,
    required List<PhraseModel> phrases,
    required LearningContext context,
    required String userId,
  }) {
    if (!_isEnabled) {
      print(
        '⚠️ [EVENT_BUS] Event bus is disabled, skipping content generation notification',
      );
      return;
    }

    print(
      '🔄 [EVENT_BUS] Notifying content generated: ${vocabularies.length} vocabularies, ${phrases.length} phrases',
    );
    print('🔄 [EVENT_BUS] Context: ${context.toJson()}, User ID: $userId');

    final eventData = ContentSyncEventData(
      type: ContentSyncEventType.contentGenerated,
      data: {
        'vocabularies': vocabularies.map((v) => v.toJson()).toList(),
        'phrases': phrases.map((p) => p.toJson()).toList(),
        'context': context.toJson(),
        'userId': userId,
      },
    );

    _emitEvent(eventData);
    print('✅ [EVENT_BUS] Content generation event emitted successfully');
  }

  /// Notifies that content has been used by the user
  /// This helps track content popularity and prevent over-reuse
  ///
  /// Parameters:
  /// - vocabularyIds: List of vocabulary IDs that were used
  /// - phraseIds: List of phrase IDs that were used
  void notifyContentUsed({
    required List<String> vocabularyIds,
    required List<String> phraseIds,
  }) {
    if (!_isEnabled) return;

    final eventData = ContentSyncEventData(
      type: ContentSyncEventType.contentUsed,
      data: {'vocabularyIds': vocabularyIds, 'phraseIds': phraseIds},
    );

    _emitEvent(eventData);
  }

  /// Notifies to check for existing content in Firebase global pool
  /// This can suggest content for reuse without generating new content
  ///
  /// Parameters:
  /// - level: User's English proficiency level
  /// - focusArea: User's learning focus area
  /// - limit: Maximum number of items to suggest
  void checkForExistingContent({
    required Level level,
    required String focusArea,
    int limit = 10,
  }) {
    if (!_isEnabled) return;

    final eventData = ContentSyncEventData(
      type: ContentSyncEventType.checkExistingContent,
      data: {'level': level.name, 'focusArea': focusArea, 'limit': limit},
    );

    _emitEvent(eventData);
  }

  /// Notifies to update user learning progress
  /// This tracks what content each user has used for personalization
  ///
  /// Parameters:
  /// - userId: User's ID
  /// - usedVocabularyIds: List of vocabulary IDs the user has used
  /// - usedPhraseIds: List of phrase IDs the user has used
  /// - preferences: User's learning preferences
  void updateUserProgress({
    required String userId,
    required List<String> usedVocabularyIds,
    required List<String> usedPhraseIds,
    required Map<String, dynamic> preferences,
  }) {
    if (!_isEnabled) return;

    final eventData = ContentSyncEventData(
      type: ContentSyncEventType.userProgressUpdated,
      data: {
        'userId': userId,
        'usedVocabularyIds': usedVocabularyIds,
        'usedPhraseIds': usedPhraseIds,
        'preferences': preferences,
      },
    );

    _emitEvent(eventData);
  }

  /// Emits an event to all registered listeners
  /// This is the internal method that broadcasts events
  ///
  /// Parameters:
  /// - eventData: The event data to emit
  void _emitEvent(ContentSyncEventData eventData) {
    print('🔄 [EVENT_BUS] Emitting event: ${eventData.type} to ${_listeners.length} listeners');
    
    for (int i = 0; i < _listeners.length; i++) {
      try {
        print('🔄 [EVENT_BUS] Calling listener ${i + 1}/${_listeners.length}');
        _listeners[i](eventData);
        print('✅ [EVENT_BUS] Listener ${i + 1} executed successfully');
      } catch (e) {
        // Log error but don't break other listeners
        print('❌ [EVENT_BUS] Error in content sync event listener ${i + 1}: $e');
      }
    }
    
    print('✅ [EVENT_BUS] Event emission completed');
  }

  /// Clears all listeners from the event bus
  /// This should be called when cleaning up resources
  void clearListeners() {
    _listeners.clear();
  }
}

// Example usage:
// // In main repository (no direct Firebase dependency)
// ContentSyncEventBus.instance.notifyContentGenerated(
//   vocabularies: newVocabularies,
//   phrases: newPhrases,
//   context: learningContext,
//   userId: 'user123',
// );
//
// // In background service (listens for events)
// ContentSyncEventBus.instance.addListener((eventData) {
//   switch (eventData.type) {
//     case ContentSyncEventType.contentGenerated:
//       // Handle content generated event
//       break;
//     case ContentSyncEventType.contentUsed:
//       // Handle content used event
//       break;
//   }
// });
