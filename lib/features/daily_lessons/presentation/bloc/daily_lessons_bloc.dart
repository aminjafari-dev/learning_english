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
import 'package:learning_english/core/usecase/usecase.dart';

/// Bloc for managing daily lessons (vocabularies and phrases)
/// Now uses conversation-based lessons to avoid repetitive content
/// Includes user-specific data management and analytics functionality
/// Now supports personalized content generation based on user preferences
/// Now includes conversation mode functionality
class DailyLessonsBloc extends Bloc<DailyLessonsEvent, DailyLessonsState> {
  final GetConversationLessonsUseCase getConversationLessonsUseCase;
  final GetUserPreferencesUseCase getUserPreferencesUseCase;

  DailyLessonsBloc({
    required this.getConversationLessonsUseCase,
    required this.getUserPreferencesUseCase,
  }) : super(
         const DailyLessonsState(
           vocabularies: VocabulariesState.initial(),
           phrases: PhrasesState.initial(),
           userPreferences: UserPreferencesState.initial(),
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
      );
    });
  }

  /// Fetches lessons through conversation mode to avoid repetitive content
  /// This method uses AI conversation to suggest new vocabularies and phrases
  /// Generated content is automatically saved to local storage for tracking
  Future<void> _onFetchConversationLessons(
    Emitter<DailyLessonsState> emit,
  ) async {
    try {
      if (!emit.isDone) {
        emit(
          state.copyWith(
            vocabularies: const VocabulariesState.loading(),
            phrases: const PhrasesState.loading(),
            userPreferences: const UserPreferencesState.loading(),
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
              userPreferences: UserPreferencesState.error(
                'Failed to get user preferences: ${failure.message}',
              ),
              isRefreshing: false,
            ),
          );
        }
        return null;
      }, (preferences) => preferences);

      if (preferences == null) return;

      // Emit user preferences state
      if (!emit.isDone) {
        emit(
          state.copyWith(
            userPreferences: UserPreferencesState.loaded(preferences),
          ),
        );
      }

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
      if (!emit.isDone) {
        emit(
          state.copyWith(userPreferences: const UserPreferencesState.loading()),
        );
      }

      final result = await getUserPreferencesUseCase(NoParams());
      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                userPreferences: UserPreferencesState.error(failure.message),
              ),
            );
          }
        },
        (preferences) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                userPreferences: UserPreferencesState.loaded(preferences),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(
          state.copyWith(
            userPreferences: UserPreferencesState.error(e.toString()),
          ),
        );
      }
    }
  }

  /// Refreshes all daily lesson content
  /// Clears local cache and fetches fresh content from conversation
  Future<void> _onRefreshLessons(Emitter<DailyLessonsState> emit) async {
    add(const DailyLessonsEvent.fetchLessons());
  }


}


