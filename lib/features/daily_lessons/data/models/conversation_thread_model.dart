// conversation_thread_model.dart
// Model for storing conversation threads in Hive database.
// This allows persistence of conversation context across app sessions.
// Now supports thread organization by user preferences (level + focus areas).

import 'package:hive/hive.dart';
import 'package:learning_english/features/daily_lessons/data/models/level_type.dart';

part 'conversation_thread_model.g.dart';

/// Model for storing conversation threads in Hive
/// Allows persistence of conversation context across app sessions
/// Threads are organized by user preferences (level + focus areas)
@HiveType(typeId: 5)
class ConversationThreadModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String threadId;

  @HiveField(2)
  final List<ConversationMessageModel> messages;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime lastUpdatedAt;

  @HiveField(5)
  final String context; // Learning context (e.g., "business vocabulary", "travel phrases")

  @HiveField(6)
  final UserLevel userLevel; // User's English level

  @HiveField(7)
  final List<String> focusAreas; // User's selected focus areas

  @HiveField(8)
  final String preferencesHash; // Unique hash for level + focus areas combination

  ConversationThreadModel({
    required this.userId,
    required this.threadId,
    required this.messages,
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.context,
    required this.userLevel,
    required this.focusAreas,
    required this.preferencesHash,
  });

  /// Create a new conversation thread with user preferences
  factory ConversationThreadModel.create({
    required String userId,
    required String context,
    required UserLevel userLevel,
    required List<String> focusAreas,
    String? geminiThreadId, // Optional Gemini thread ID
  }) {
    final preferencesHash = _generatePreferencesHash(userLevel, focusAreas);

    // Use Gemini thread ID if provided, otherwise generate our own
    final threadId =
        geminiThreadId ??
        'thread_${preferencesHash}_${DateTime.now().millisecondsSinceEpoch}';

    return ConversationThreadModel(
      userId: userId,
      threadId: threadId,
      messages: [],
      createdAt: DateTime.now(),
      lastUpdatedAt: DateTime.now(),
      context: context,
      userLevel: userLevel,
      focusAreas: focusAreas,
      preferencesHash: preferencesHash,
    );
  }

  /// Generate unique hash for level + focus areas combination
  /// This ensures each unique preference combination gets its own thread
  static String _generatePreferencesHash(
    UserLevel level,
    List<String> focusAreas,
  ) {
    final sortedAreas = List<String>.from(focusAreas)..sort();
    final combined = '${level.name}_${sortedAreas.join('_')}';
    return combined.toLowerCase().replaceAll(' ', '_');
  }

  /// Check if this thread matches the given user preferences
  bool matchesPreferences(UserLevel level, List<String> focusAreas) {
    if (userLevel != level) return false;

    if (this.focusAreas.length != focusAreas.length) return false;

    final sortedCurrent = List<String>.from(this.focusAreas)..sort();
    final sortedGiven = List<String>.from(focusAreas)..sort();

    return sortedCurrent.join(',') == sortedGiven.join(',');
  }

  /// Get a human-readable description of the thread preferences
  String get preferencesDescription {
    final levelDesc = userLevel.name.toLowerCase();
    final areasDesc = focusAreas.join(', ');
    return '$levelDesc level - $areasDesc';
  }

  /// Add a message to the thread
  ConversationThreadModel addMessage(ConversationMessageModel message) {
    final updatedMessages = List<ConversationMessageModel>.from(messages)
      ..add(message);

    return copyWith(messages: updatedMessages, lastUpdatedAt: DateTime.now());
  }

  /// Get the last message in the thread
  ConversationMessageModel? get lastMessage {
    if (messages.isEmpty) return null;
    return messages.last;
  }

  /// Get conversation summary for context
  String get conversationSummary {
    if (messages.isEmpty) return 'No conversation history';

    final userMessages = messages.where((m) => m.role == 'user').length;
    final modelMessages = messages.where((m) => m.role == 'model').length;

    return 'Conversation with $userMessages user messages and $modelMessages AI responses for ${preferencesDescription}';
  }

  /// Copy with new values
  ConversationThreadModel copyWith({
    String? userId,
    String? threadId,
    List<ConversationMessageModel>? messages,
    DateTime? createdAt,
    DateTime? lastUpdatedAt,
    String? context,
    UserLevel? userLevel,
    List<String>? focusAreas,
    String? preferencesHash,
  }) {
    return ConversationThreadModel(
      userId: userId ?? this.userId,
      threadId: threadId ?? this.threadId,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      context: context ?? this.context,
      userLevel: userLevel ?? this.userLevel,
      focusAreas: focusAreas ?? this.focusAreas,
      preferencesHash: preferencesHash ?? this.preferencesHash,
    );
  }

  @override
  String toString() {
    return 'ConversationThreadModel(userId: $userId, threadId: $threadId, messages: ${messages.length}, preferences: ${preferencesDescription})';
  }
}

/// Model for individual conversation messages
@HiveType(typeId: 6)
class ConversationMessageModel {
  @HiveField(0)
  final String role; // 'user' or 'model'

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime timestamp;

  @HiveField(3)
  final Map<String, dynamic>? metadata; // Additional data like tokens used, cost, etc.

  ConversationMessageModel({
    required this.role,
    required this.content,
    required this.timestamp,
    this.metadata,
  });

  /// Create a user message
  factory ConversationMessageModel.user(String content) {
    return ConversationMessageModel(
      role: 'user',
      content: content,
      timestamp: DateTime.now(),
    );
  }

  /// Create a model message
  factory ConversationMessageModel.model(
    String content, {
    Map<String, dynamic>? metadata,
  }) {
    return ConversationMessageModel(
      role: 'model',
      content: content,
      timestamp: DateTime.now(),
      metadata: metadata,
    );
  }

  /// Check if this is a user message
  bool get isUserMessage => role == 'user';

  /// Check if this is a model message
  bool get isModelMessage => role == 'model';

  @override
  String toString() {
    return 'ConversationMessageModel(role: $role, content: ${content.length} chars, timestamp: $timestamp)';
  }
}
