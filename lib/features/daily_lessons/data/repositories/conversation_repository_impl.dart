// conversation_repository_impl.dart
// Implementation of ConversationRepository interface.
// This class handles conversation threads and AI-powered messaging functionality.
// Manages conversation state, thread creation, and message processing with AI services.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/repositories/user_repository.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../datasources/local/daily_lessons_local_data_source.dart';
import '../datasources/remote/gemini_conversation_service.dart';
import '../models/conversation_thread_model.dart';
import '../models/level_type.dart';

/// Implementation of ConversationRepository
/// Handles AI-powered conversation threads for interactive learning
/// Manages conversation persistence and AI interaction through Gemini service
class ConversationRepositoryImpl implements ConversationRepository {
  final DailyLessonsLocalDataSource localDataSource;
  final GeminiConversationService geminiConversationService;
  final UserRepository coreUserRepository;

  /// Constructor for dependency injection
  /// Requires local data source for conversation persistence,
  /// Gemini service for AI interactions, and core user repository for authentication
  ConversationRepositoryImpl({
    required this.localDataSource,
    required this.geminiConversationService,
    required this.coreUserRepository,
  });

  @override
  Future<Either<Failure, String>> sendConversationMessage(
    UserPreferences preferences,
    String message,
  ) async {
    try {
      print('💬 [CONVERSATION] Starting conversation message processing');
      print(
        '📋 [CONVERSATION] User preferences: level=${preferences.level}, areas=${preferences.focusAreas}',
      );
      print('📝 [CONVERSATION] User message: $message');

      // Get user ID for conversation tracking
      final userId = await coreUserRepository.getUserId() ?? 'current_user';
      print('👤 [CONVERSATION] User ID: $userId');

      // Convert UserLevel to the model's UserLevel
      final userLevel = _convertToModelUserLevel(preferences.level);

      // Get or create conversation thread based on user preferences
      ConversationThreadModel? conversationThread = await localDataSource
          .findThreadByPreferences(userId, userLevel, preferences.focusAreas);

      if (conversationThread == null) {
        // Create new thread if none exists
        print('🆕 [CONVERSATION] Creating new conversation thread');
        conversationThread = ConversationThreadModel.create(
          userId: userId,
          context: _generateContext(preferences),
          userLevel: userLevel,
          focusAreas: preferences.focusAreas,
        );

        // Save the new thread
        await localDataSource.saveConversationThread(conversationThread);
        print('💾 [CONVERSATION] Saved new thread to storage');
      } else {
        print(
          '✅ [CONVERSATION] Retrieved existing thread with ${conversationThread.messages.length} messages',
        );
      }

      // Send to AI service (Gemini) and get response
      print('🤖 [CONVERSATION] Sending to Gemini AI service');
      try {
        final aiResponse = await geminiConversationService.sendMessage(
          userId,
          message,
          userLevel: userLevel,
          focusAreas: preferences.focusAreas,
        );

        print(
          '✅ [CONVERSATION] Received AI response: ${aiResponse.substring(0, 50)}...',
        );
        print('✅ [CONVERSATION] Conversation message processed successfully');
        return right(aiResponse);
      } catch (e) {
        print('❌ [CONVERSATION] Gemini service error: $e');
        return left(
          ServerFailure('Failed to get AI response: ${e.toString()}'),
        );
      }
    } catch (e) {
      print('❌ [CONVERSATION] Unexpected error in conversation processing: $e');
      return left(
        ServerFailure(
          'Failed to process conversation message: ${e.toString()}',
        ),
      );
    }
  }

  /// Generates conversation context based on user preferences
  /// Creates a descriptive context for the conversation thread
  String _generateContext(UserPreferences preferences) {
    return 'AI conversation for ${preferences.level.name} level focusing on ${preferences.focusAreas.join(", ")}';
  }

  /// Converts domain UserLevel to model UserLevel
  /// Maps between different level representations in the system
  UserLevel _convertToModelUserLevel(dynamic preferences_level) {
    switch (preferences_level.toString()) {
      case 'UserLevel.beginner':
        return UserLevel.beginner;
      case 'UserLevel.elementary':
        return UserLevel.elementary;
      case 'UserLevel.intermediate':
        return UserLevel.intermediate;
      case 'UserLevel.advanced':
        return UserLevel.advanced;
      default:
        return UserLevel.intermediate; // Default fallback
    }
  }
}

// Example usage:
// final conversationRepo = ConversationRepositoryImpl(
//   localDataSource: getIt<DailyLessonsLocalDataSource>(),
//   geminiConversationService: getIt<GeminiConversationService>(),
//   coreUserRepository: getIt<UserRepository>(),
// );
// 
// // Send conversation message
// final preferences = UserPreferences(level: UserLevel.intermediate, focusAreas: ['technology']);
// final response = await conversationRepo.sendConversationMessage(
//   preferences,
//   "Explain machine learning in simple terms"
// );
// response.fold(
//   (failure) => print('Error: ${failure.message}'),
//   (aiResponse) => print('AI: $aiResponse'),
// );