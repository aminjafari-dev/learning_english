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
  /// Generates AI conversation response using database-driven prompts
  /// Uses dynamic prompts and user preferences for personalized educational content
  ///
  /// This method:
  /// 1. Processes user preferences (level and focus areas)
  /// 2. Edge Function automatically selects appropriate prompts from database
  /// 3. Generates AI response with educational content
  /// 4. Automatically extracts and stores vocabularies/phrases
  /// 5. Returns personalized learning content
  ///
  /// Parameters:
  /// - preferences: User's level and focus areas for conversation context
  ///
  /// Returns: Either Failure or String (AI response with educational content)
  ///
  /// Example usage:
  /// ```dart
  /// final response = await conversationRepository.generateConversationResponse(preferences);
  /// response.fold(
  ///   (failure) => print('Error: ${failure.message}'),
  ///   (aiResponse) => print('AI: $aiResponse'),
  /// );
  /// ```
  Future<Either<Failure, String>> generateConversationResponse(
    UserPreferences preferences,
  );
}

// Example usage:
// final repo = ... // get from DI
// 
// // Start conversation
// final preferences = UserPreferences(level: UserLevel.intermediate, focusAreas: ['technology']);
// final thread = await repo.getConversationThread(preferences);
// 
// // Generate conversation response
// final response = await repo.generateConversationResponse(preferences);
// 
// // Get conversation history
// final threads = await repo.getUserConversationThreads();
// 
// // Clear all conversations
// await repo.clearUserConversationThreads();