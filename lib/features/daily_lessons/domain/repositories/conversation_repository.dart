// conversation_repository.dart
// Repository interface for managing conversation threads and messaging functionality.
// This repository handles AI-powered conversations for interactive learning sessions.
// Separates conversation management from core daily lessons functionality.

import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_preferences.dart';

/// Abstract repository for conversation management
/// Handles conversation threads, message sending, and conversation history
/// Provides interactive AI conversation capabilities for enhanced learning
abstract class ConversationRepository {

  /// Sends a message in conversation mode
  /// Uses the existing thread for the user's preferences or creates a new one
  ///
  /// This method:
  /// 1. Gets or creates conversation thread for user preferences
  /// 2. Adds user message to the thread
  /// 3. Sends message to AI conversation service
  /// 4. Adds AI response to the thread
  /// 5. Saves updated thread with complete conversation history
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas for conversation context
  /// - message: The user's message to send to the AI
  ///
  /// Returns: Either Failure or String (AI response)
  ///
  /// Example usage:
  /// ```dart
  /// final response = await conversationRepository.sendConversationMessage(
  ///   preferences,
  ///   "Can you explain the difference between 'affect' and 'effect'?"
  /// );
  /// response.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (aiResponse) => print('AI: $aiResponse'),
  /// );
  /// ```
  Future<Either<Failure, String>> sendConversationMessage(
    UserPreferences preferences,
    String message,
  );

}

// Example usage:
// final repo = ... // get from DI
// 
// // Start conversation
// final preferences = UserPreferences(level: UserLevel.intermediate, focusAreas: ['technology']);
// final thread = await repo.getConversationThread(preferences);
// 
// // Send message
// final response = await repo.sendConversationMessage(
//   preferences,
//   "Explain machine learning in simple terms"
// );
// 
// // Get conversation history
// final threads = await repo.getUserConversationThreads();
// 
// // Clear all conversations
// await repo.clearUserConversationThreads();