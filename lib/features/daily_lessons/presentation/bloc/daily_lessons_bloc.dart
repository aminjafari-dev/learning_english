// daily_lessons_bloc.dart
// Bloc for managing daily lessons operations.
// Now uses conversation-based lessons to avoid repetitive content.
// Now includes user-specific data management and analytics functionality.
// Now supports personalized content generation based on user preferences.

import 'package:bloc/bloc.dart';
import 'daily_lessons_event.dart';
import 'daily_lessons_state.dart';
import '../../domain/usecases/get_conversation_lessons_usecase.dart';
import '../../domain/usecases/get_user_preferences_usecase.dart';
import '../../domain/usecases/send_conversation_message_usecase.dart';
import '../../domain/entities/user_preferences.dart';
import '../../data/models/conversation_thread_model.dart';
import '../../data/models/level_type.dart';
import 'package:learning_english/core/usecase/usecase.dart';

/// Bloc for managing daily lessons (vocabularies and phrases)
/// Now uses conversation-based lessons to avoid repetitive content
/// Includes user-specific data management and analytics functionality
/// Now supports personalized content generation based on user preferences
/// Now includes conversation mode functionality
class DailyLessonsBloc extends Bloc<DailyLessonsEvent, DailyLessonsState> {
  final GetConversationLessonsUseCase getConversationLessonsUseCase;
  final GetUserPreferencesUseCase getUserPreferencesUseCase;
  final SendConversationMessageUseCase sendConversationMessageUseCase;

  DailyLessonsBloc({
    required this.getConversationLessonsUseCase,
    required this.getUserPreferencesUseCase,
    required this.sendConversationMessageUseCase,
  }) : super(
         const DailyLessonsState(
           vocabularies: VocabulariesState.initial(),
           phrases: PhrasesState.initial(),
           analytics: UserAnalyticsState.initial(),
           dataManagement: UserDataManagementState.initial(),
           conversation: ConversationState.initial(),
           isRefreshing: false,
         ),
       ) {
    on<DailyLessonsEvent>((event, emit) async {
      await event.when(
        fetchLessons:
            () => _onFetchConversationLessons(
              emit,
            ), // New conversation-based method
        refreshLessons: () => _onRefreshLessons(emit),
        getUserPreferences: () => _onGetUserPreferences(emit),
        sendConversationMessage:
            (preferences, message) =>
                _onSendConversationMessage(preferences, message, emit),
      );
    });
  }

  /// Fetches lessons through conversation mode to avoid repetitive content
  /// This method uses AI conversation to suggest new vocabularies and phrases
  Future<void> _onFetchConversationLessons(
    Emitter<DailyLessonsState> emit,
  ) async {
    try {
      if (!emit.isDone) {
        emit(
          state.copyWith(
            vocabularies: const VocabulariesState.loading(),
            phrases: const PhrasesState.loading(),
            isRefreshing: true,
          ),
        );
      }

      // First get user preferences
      final preferencesResult = await getUserPreferencesUseCase(NoParams());
      final preferences = preferencesResult.fold((failure) {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              vocabularies: VocabulariesState.error(
                'Failed to get user preferences: ${failure.message}',
              ),
              phrases: PhrasesState.error(
                'Failed to get user preferences: ${failure.message}',
              ),
              isRefreshing: false,
            ),
          );
        }
        return null;
      }, (preferences) => preferences);

      if (preferences == null) return;

      // Then fetch conversation-based lessons using the preferences
      final result = await getConversationLessonsUseCase(preferences);
      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                vocabularies: VocabulariesState.error(failure.message),
                phrases: PhrasesState.error(failure.message),
                isRefreshing: false,
              ),
            );
          }
        },
        (data) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                vocabularies: VocabulariesState.loaded(data.vocabularies),
                phrases: PhrasesState.loaded(data.phrases),
                isRefreshing: false,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(
          state.copyWith(
            vocabularies: VocabulariesState.error(
              'Failed to fetch conversation lessons: ${e.toString()}',
            ),
            phrases: PhrasesState.error(
              'Failed to fetch conversation lessons: ${e.toString()}',
            ),
            isRefreshing: false,
          ),
        );
      }
    }
  }

  /// Gets user preferences for personalized content generation
  /// Returns user's level and selected learning focus areas
  Future<void> _onGetUserPreferences(Emitter<DailyLessonsState> emit) async {
    try {
      final result = await getUserPreferencesUseCase(NoParams());
      result.fold(
        (failure) {
          // Don't emit error state for preferences, just log it
          print('⚠️ [BLOC] Failed to get user preferences: ${failure.message}');
        },
        (preferences) {
          print('✅ [BLOC] Retrieved user preferences: $preferences');
          // You could emit a state with preferences if needed
          // For now, we'll just log it
        },
      );
    } catch (e) {
      print('❌ [BLOC] Error getting user preferences: $e');
    }
  }

  /// Refreshes all daily lesson content
  /// Clears local cache and fetches fresh content from conversation
  Future<void> _onRefreshLessons(Emitter<DailyLessonsState> emit) async {
    add(const DailyLessonsEvent.fetchLessons());
  }

  // ===== CONVERSATION EVENT HANDLERS =====

  /// Send a message in conversation mode
  /// Uses existing thread or creates new one based on preferences
  Future<void> _onSendConversationMessage(
    UserPreferences preferences,
    String message,
    Emitter<DailyLessonsState> emit,
  ) async {
    try {
      emit(state.copyWith(conversation: const ConversationState.loading()));

      final result = await sendConversationMessageUseCase((
        preferences: preferences,
        message: message,
      ));

      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                conversation: ConversationState.error(failure.message),
              ),
            );
          }
        },
        (response) {
          if (!emit.isDone) {
            // Get current conversation state
            final currentState = state.conversation;
            if (currentState is ConversationLoaded) {
              // Add user message and AI response to messages
              final userMessage = ConversationMessageModel.user(message);
              final aiMessage = ConversationMessageModel.model(response);
              final updatedMessages = [
                ...currentState.messages,
                userMessage,
                aiMessage,
              ];

              emit(
                state.copyWith(
                  conversation: ConversationState.loaded(
                    currentThread: currentState.currentThread,
                    messages: updatedMessages,
                    userThreads: currentState.userThreads,
                  ),
                ),
              );
            } else {
              // Create new conversation state
              final thread = ConversationThreadModel.create(
                userId: 'current_user',
                context: 'conversation',
                userLevel: UserLevel.intermediate,
                focusAreas: preferences.focusAreas,
              );

              final userMessage = ConversationMessageModel.user(message);
              final aiMessage = ConversationMessageModel.model(response);

              emit(
                state.copyWith(
                  conversation: ConversationState.loaded(
                    currentThread: thread,
                    messages: [userMessage, aiMessage],
                    userThreads: [],
                  ),
                ),
              );
            }
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(
          state.copyWith(conversation: ConversationState.error(e.toString())),
        );
      }
    }
  }
}
