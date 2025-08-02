// conversation_threads_local_data_source.dart
// Specialized local data source for managing conversation thread CRUD operations using Hive.
// This class handles persistence of conversation history and thread management for Gemini integration.
// Usage: Use this class to store, retrieve, and manage conversation thread data locally.

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/conversation_thread_model.dart';
import '../../models/level_type.dart';

/// Specialized local data source for conversation threads storage using Hive
/// This class focuses solely on conversation thread CRUD operations and preference matching
/// Usage: Initialize once, then use methods to manage conversation thread data
class ConversationThreadsLocalDataSource {
  static const String _boxName = 'conversation_threads';

  late Box<ConversationThreadModel> _box;

  /// Initialize Hive box for conversation thread storage
  /// This method should be called before using any other methods
  /// Example: await dataSource.initialize();
  Future<void> initialize() async {
    try {
      _box = await Hive.openBox<ConversationThreadModel>(_boxName);
    } catch (e) {
      throw Exception(
        'Failed to initialize conversation threads box: ${e.toString()}',
      );
    }
  }

  /// Saves a conversation thread to Hive
  /// Stores the complete conversation history for persistence across app sessions
  /// Example: await dataSource.saveConversationThread(threadModel);
  Future<void> saveConversationThread(ConversationThreadModel thread) async {
    try {
      await _box.put(thread.threadId, thread);
    } catch (e) {
      throw Exception('Failed to save conversation thread: ${e.toString()}');
    }
  }

  /// Retrieves all conversation threads for a specific user
  /// Returns list of ConversationThreadModel with complete conversation history
  /// Example: final threads = await dataSource.getUserConversationThreads('user123');
  Future<List<ConversationThreadModel>> getUserConversationThreads(
    String userId,
  ) async {
    try {
      return _box.values.where((thread) => thread.userId == userId).toList();
    } catch (e) {
      throw Exception(
        'Failed to get user conversation threads: ${e.toString()}',
      );
    }
  }

  /// Retrieves a specific conversation thread by ID
  /// Returns the complete thread with all messages and metadata
  /// Example: final thread = await dataSource.getConversationThreadById('thread123');
  Future<ConversationThreadModel?> getConversationThreadById(
    String threadId,
  ) async {
    try {
      return _box.get(threadId);
    } catch (e) {
      throw Exception(
        'Failed to get conversation thread by ID: ${e.toString()}',
      );
    }
  }

  /// Updates a conversation thread with new messages
  /// Adds new messages to existing thread and updates metadata
  /// Example: await dataSource.updateConversationThread(updatedThread);
  Future<void> updateConversationThread(
    ConversationThreadModel updatedThread,
  ) async {
    try {
      await _box.put(updatedThread.threadId, updatedThread);
    } catch (e) {
      throw Exception('Failed to update conversation thread: ${e.toString()}');
    }
  }

  /// Deletes a conversation thread
  /// Removes the thread and all its messages permanently
  /// Example: await dataSource.deleteConversationThread('thread123');
  Future<void> deleteConversationThread(String threadId) async {
    try {
      await _box.delete(threadId);
    } catch (e) {
      throw Exception('Failed to delete conversation thread: ${e.toString()}');
    }
  }

  /// Clears all conversation threads for a user
  /// Used when user wants to reset their conversation history completely
  /// Example: await dataSource.clearUserConversationThreads('user123');
  Future<void> clearUserConversationThreads(String userId) async {
    try {
      final userThreads = await getUserConversationThreads(userId);
      // Delete each user thread from storage
      for (final thread in userThreads) {
        await _box.delete(thread.threadId);
      }
    } catch (e) {
      throw Exception(
        'Failed to clear user conversation threads: ${e.toString()}',
      );
    }
  }

  /// Find conversation thread by user preferences
  /// Returns existing thread if found with matching level and focus areas, null otherwise
  /// Example: final thread = await dataSource.findThreadByPreferences('user123', UserLevel.intermediate, ['vocabulary']);
  Future<ConversationThreadModel?> findThreadByPreferences(
    String userId,
    UserLevel level,
    List<String> focusAreas,
  ) async {
    try {
      final userThreads = await getUserConversationThreads(userId);

      // Find thread that matches the exact preferences
      for (final thread in userThreads) {
        if (thread.matchesPreferences(level, focusAreas)) {
          return thread;
        }
      }

      return null; // No matching thread found
    } catch (e) {
      throw Exception('Failed to find thread by preferences: ${e.toString()}');
    }
  }

  /// Get all threads for a user with their preference descriptions
  /// Returns list of threads with their preference information for UI display
  /// Example: final threadsInfo = await dataSource.getUserThreadsWithPreferences('user123');
  Future<List<Map<String, dynamic>>> getUserThreadsWithPreferences(
    String userId,
  ) async {
    try {
      final userThreads = await getUserConversationThreads(userId);

      return userThreads
          .map(
            (thread) => {
              'thread': thread,
              'preferencesDescription': thread.preferencesDescription,
              'messageCount': thread.messages.length,
              'lastActivity': thread.lastUpdatedAt.toIso8601String(),
            },
          )
          .toList();
    } catch (e) {
      throw Exception(
        'Failed to get user threads with preferences: ${e.toString()}',
      );
    }
  }

  /// Gets conversation analytics for a user
  /// Returns statistics about conversation usage and activity patterns
  /// Example: final analytics = await dataSource.getConversationAnalytics('user123');
  Future<Map<String, dynamic>> getConversationAnalytics(String userId) async {
    try {
      final userThreads = await getUserConversationThreads(userId);

      final totalThreads = userThreads.length;

      // Calculate total messages across all threads
      final totalMessages = userThreads.fold<int>(
        0,
        (sum, thread) => sum + thread.messages.length,
      );

      // Count user messages specifically
      final userMessages = userThreads.fold<int>(
        0,
        (sum, thread) =>
            sum + thread.messages.where((m) => m.isUserMessage).length,
      );

      // Count model/AI messages specifically
      final modelMessages = userThreads.fold<int>(
        0,
        (sum, thread) =>
            sum + thread.messages.where((m) => m.isModelMessage).length,
      );

      // Get unique contexts from all threads
      final contexts = userThreads.map((t) => t.context).toSet().toList();

      // Find the most recent activity
      final lastActivity =
          userThreads.isNotEmpty
              ? userThreads
                  .map((t) => t.lastUpdatedAt)
                  .reduce((a, b) => a.isAfter(b) ? a : b)
                  .toIso8601String()
              : null;

      return {
        'totalThreads': totalThreads,
        'totalMessages': totalMessages,
        'userMessages': userMessages,
        'modelMessages': modelMessages,
        'contexts': contexts,
        'lastActivity': lastActivity,
      };
    } catch (e) {
      throw Exception('Failed to get conversation analytics: ${e.toString()}');
    }
  }

  /// Closes the Hive box to free up resources
  /// Should be called when the data source is no longer needed
  /// Example: await dataSource.dispose();
  Future<void> dispose() async {
    try {
      await _box.close();
    } catch (e) {
      throw Exception(
        'Failed to dispose conversation threads data source: ${e.toString()}',
      );
    }
  }
}

// Example usage:
// final dataSource = ConversationThreadsLocalDataSource();
// await dataSource.initialize();
// await dataSource.saveConversationThread(threadModel);
// final threads = await dataSource.getUserConversationThreads('user123');
// final analytics = await dataSource.getConversationAnalytics('user123');
// await dataSource.dispose();
