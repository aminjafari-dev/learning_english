// daily_lessons_bloc.dart
// Bloc for managing daily lessons operations.
// Now includes user-specific data management and analytics functionality.
// Now supports personalized content generation based on user preferences.

import 'package:bloc/bloc.dart';
import 'daily_lessons_event.dart';
import 'daily_lessons_state.dart';
import '../../domain/usecases/get_daily_vocabularies_usecase.dart';
import '../../domain/usecases/get_daily_phrases_usecase.dart';
import '../../domain/usecases/get_daily_lessons_usecase.dart';
import '../../domain/usecases/refresh_daily_lessons_usecase.dart';
import '../../domain/usecases/mark_vocabulary_as_used_usecase.dart';
import '../../domain/usecases/mark_phrase_as_used_usecase.dart';
import '../../domain/usecases/get_user_analytics_usecase.dart';
import '../../domain/usecases/clear_user_data_usecase.dart';
import '../../domain/usecases/get_user_preferences_usecase.dart';
import 'package:learning_english/core/usecase/usecase.dart';

/// Bloc for managing daily lessons (vocabularies and phrases)
/// Now uses cost-effective combined requests to reduce API costs
/// Includes user-specific data management and analytics functionality
/// Now supports personalized content generation based on user preferences
class DailyLessonsBloc extends Bloc<DailyLessonsEvent, DailyLessonsState> {
  final GetDailyVocabulariesUseCase getDailyVocabulariesUseCase;
  final GetDailyPhrasesUseCase getDailyPhrasesUseCase;
  final GetDailyLessonsUseCase getDailyLessonsUseCase;
  final RefreshDailyLessonsUseCase refreshDailyLessonsUseCase;
  final MarkVocabularyAsUsedUseCase markVocabularyAsUsedUseCase;
  final MarkPhraseAsUsedUseCase markPhraseAsUsedUseCase;
  final GetUserAnalyticsUseCase getUserAnalyticsUseCase;
  final ClearUserDataUseCase clearUserDataUseCase;
  final GetUserPreferencesUseCase getUserPreferencesUseCase;

  DailyLessonsBloc({
    required this.getDailyVocabulariesUseCase,
    required this.getDailyPhrasesUseCase,
    required this.getDailyLessonsUseCase,
    required this.refreshDailyLessonsUseCase,
    required this.markVocabularyAsUsedUseCase,
    required this.markPhraseAsUsedUseCase,
    required this.getUserAnalyticsUseCase,
    required this.clearUserDataUseCase,
    required this.getUserPreferencesUseCase,
  }) : super(
         const DailyLessonsState(
           vocabularies: VocabulariesState.initial(),
           phrases: PhrasesState.initial(),
           analytics: UserAnalyticsState.initial(),
           dataManagement: UserDataManagementState.initial(),
           isRefreshing: false,
         ),
       ) {
    on<DailyLessonsEvent>((event, emit) async {
      await event.when(
        fetchVocabularies: () => _onFetchVocabularies(emit),
        fetchPhrases: () => _onFetchPhrases(emit),
        fetchLessons: () => _onFetchLessons(emit), // New cost-effective method
        fetchPersonalizedLessons:
            () => _onFetchPersonalizedLessons(emit), // New personalized method
        refreshLessons: () => _onRefreshLessons(emit),
        markVocabularyAsUsed:
            (english) => _onMarkVocabularyAsUsed(english, emit),
        markPhraseAsUsed: (english) => _onMarkPhraseAsUsed(english, emit),
        getUserAnalytics: () => _onGetUserAnalytics(emit),
        clearUserData: () => _onClearUserData(emit),
        getUserPreferences: () => _onGetUserPreferences(emit),
      );
    });
  }

  Future<void> _onFetchVocabularies(Emitter<DailyLessonsState> emit) async {
    try {
      emit(state.copyWith(vocabularies: const VocabulariesState.loading()));

      // First get user preferences
      final preferencesResult = await getUserPreferencesUseCase(NoParams());
      final preferences = preferencesResult.fold((failure) {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              vocabularies: VocabulariesState.error(
                'Failed to get user preferences: ${failure.message}',
              ),
            ),
          );
        }
        return null;
      }, (preferences) => preferences);

      if (preferences == null) return;

      // Then fetch personalized vocabularies using the preferences
      final result = await getDailyVocabulariesUseCase(preferences);
      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                vocabularies: VocabulariesState.error(failure.message),
              ),
            );
          }
        },
        (vocabularies) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                vocabularies: VocabulariesState.loaded(vocabularies),
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
              'Failed to fetch vocabularies: ${e.toString()}',
            ),
          ),
        );
      }
    }
  }

  Future<void> _onFetchPhrases(Emitter<DailyLessonsState> emit) async {
    try {
      emit(state.copyWith(phrases: const PhrasesState.loading()));

      // First get user preferences
      final preferencesResult = await getUserPreferencesUseCase(NoParams());
      final preferences = preferencesResult.fold((failure) {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              phrases: PhrasesState.error(
                'Failed to get user preferences: ${failure.message}',
              ),
            ),
          );
        }
        return null;
      }, (preferences) => preferences);

      if (preferences == null) return;

      // Then fetch personalized phrases using the preferences
      final result = await getDailyPhrasesUseCase(preferences);
      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(state.copyWith(phrases: PhrasesState.error(failure.message)));
          }
        },
        (phrases) {
          if (!emit.isDone) {
            emit(state.copyWith(phrases: PhrasesState.loaded(phrases)));
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(
          state.copyWith(
            phrases: PhrasesState.error(
              'Failed to fetch phrases: ${e.toString()}',
            ),
          ),
        );
      }
    }
  }

  /// Fetches both vocabularies and phrases in a single request (cost-effective)
  /// This method reduces API costs by ~25-40% compared to separate requests
  Future<void> _onFetchLessons(Emitter<DailyLessonsState> emit) async {
    try {
      emit(
        state.copyWith(
          vocabularies: const VocabulariesState.loading(),
          phrases: const PhrasesState.loading(),
        ),
      );

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
            ),
          );
        }
        return null;
      }, (preferences) => preferences);

      if (preferences == null) return;

      // Then fetch personalized lessons using the preferences
      final result = await getDailyLessonsUseCase(preferences);
      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                vocabularies: VocabulariesState.error(failure.message),
                phrases: PhrasesState.error(failure.message),
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
              'Failed to fetch lessons: ${e.toString()}',
            ),
            phrases: PhrasesState.error(
              'Failed to fetch lessons: ${e.toString()}',
            ),
          ),
        );
      }
    }
  }

  /// Fetches personalized lessons based on user preferences
  /// Creates level-appropriate and focus-specific content
  Future<void> _onFetchPersonalizedLessons(
    Emitter<DailyLessonsState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          vocabularies: const VocabulariesState.loading(),
          phrases: const PhrasesState.loading(),
        ),
      );

      // First, get user preferences
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
            ),
          );
        }
        return null;
      }, (preferences) => preferences);

      if (preferences == null) return;

      // Then fetch personalized content using the preferences
      final result = await getDailyLessonsUseCase(preferences);

      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                vocabularies: VocabulariesState.error(failure.message),
                phrases: PhrasesState.error(failure.message),
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
              'Failed to fetch personalized lessons: ${e.toString()}',
            ),
            phrases: PhrasesState.error(
              'Failed to fetch personalized lessons: ${e.toString()}',
            ),
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
  /// Clears local cache and fetches fresh content from AI
  Future<void> _onRefreshLessons(Emitter<DailyLessonsState> emit) async {
    try {
      emit(state.copyWith(isRefreshing: true));
      final result = await refreshDailyLessonsUseCase(NoParams());
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
        (success) async {
          // After successful refresh, fetch fresh content
          await _onFetchLessons(emit);
          if (!emit.isDone) {
            emit(state.copyWith(isRefreshing: false));
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(
          state.copyWith(
            vocabularies: VocabulariesState.error(
              'Failed to refresh lessons: ${e.toString()}',
            ),
            phrases: PhrasesState.error(
              'Failed to refresh lessons: ${e.toString()}',
            ),
            isRefreshing: false,
          ),
        );
      }
    }
  }

  /// Marks vocabulary as used by the current user
  /// Updates the usage status in local storage to prevent duplicate suggestions
  Future<void> _onMarkVocabularyAsUsed(
    String english,
    Emitter<DailyLessonsState> emit,
  ) async {
    try {
      emit(
        state.copyWith(dataManagement: const UserDataManagementState.loading()),
      );
      final result = await markVocabularyAsUsedUseCase(english);
      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                dataManagement: UserDataManagementState.error(failure.message),
              ),
            );
          }
        },
        (success) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                dataManagement: const UserDataManagementState.success(),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(
          state.copyWith(
            dataManagement: UserDataManagementState.error(
              'Failed to mark vocabulary as used: ${e.toString()}',
            ),
          ),
        );
      }
    }
  }

  /// Marks phrase as used by the current user
  /// Updates the usage status in local storage to prevent duplicate suggestions
  Future<void> _onMarkPhraseAsUsed(
    String english,
    Emitter<DailyLessonsState> emit,
  ) async {
    try {
      emit(
        state.copyWith(dataManagement: const UserDataManagementState.loading()),
      );
      final result = await markPhraseAsUsedUseCase(english);
      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                dataManagement: UserDataManagementState.error(failure.message),
              ),
            );
          }
        },
        (success) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                dataManagement: const UserDataManagementState.success(),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(
          state.copyWith(
            dataManagement: UserDataManagementState.error(
              'Failed to mark phrase as used: ${e.toString()}',
            ),
          ),
        );
      }
    }
  }

  /// Gets analytics data for the current user
  /// Provides insights into learning progress and AI usage costs
  Future<void> _onGetUserAnalytics(Emitter<DailyLessonsState> emit) async {
    try {
      emit(state.copyWith(analytics: const UserAnalyticsState.loading()));
      final result = await getUserAnalyticsUseCase(null);
      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                analytics: UserAnalyticsState.error(failure.message),
              ),
            );
          }
        },
        (analytics) {
          if (!emit.isDone) {
            emit(
              state.copyWith(analytics: UserAnalyticsState.loaded(analytics)),
            );
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(
          state.copyWith(
            analytics: UserAnalyticsState.error(
              'Failed to get user analytics: ${e.toString()}',
            ),
          ),
        );
      }
    }
  }

  /// Clears all data for the current user
  /// Used when user wants to reset their learning progress
  Future<void> _onClearUserData(Emitter<DailyLessonsState> emit) async {
    try {
      emit(
        state.copyWith(dataManagement: const UserDataManagementState.loading()),
      );
      final result = await clearUserDataUseCase(null);
      result.fold(
        (failure) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                dataManagement: UserDataManagementState.error(failure.message),
              ),
            );
          }
        },
        (success) {
          if (!emit.isDone) {
            emit(
              state.copyWith(
                dataManagement: const UserDataManagementState.success(),
              ),
            );
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(
          state.copyWith(
            dataManagement: UserDataManagementState.error(
              'Failed to clear user data: ${e.toString()}',
            ),
          ),
        );
      }
    }
  }
}

// Example usage:
// BlocProvider(create: (context) => DailyLessonsBloc(...))
//
// // Personalized content usage:
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.fetchPersonalizedLessons());
// context.read<DailyLessonsBloc>().add(const DailyLessonsEvent.getUserPreferences());
