// send_conversation_message_usecase.dart
// Use case for sending messages in conversation mode.
// This use case handles sending messages to existing threads or creating new ones.

import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../entities/user_preferences.dart';
import '../repositories/conversation_repository.dart';

/// Use case for sending messages in conversation mode
/// Uses existing thread for the user's preferences or creates a new one
/// Updated to use dedicated ConversationRepository
class SendConversationMessageUseCase
    implements
        UseCase<String, ({UserPreferences preferences, String message})> {
  final ConversationRepository repository;

  SendConversationMessageUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(
    ({UserPreferences preferences, String message}) params,
  ) async {
    // Send conversation message using the dedicated repository
    // This handles thread management and AI interaction
    return await repository.sendConversationMessage(
      params.preferences,
      params.message,
    );
  }
}
