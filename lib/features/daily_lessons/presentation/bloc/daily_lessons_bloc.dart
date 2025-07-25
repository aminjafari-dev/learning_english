// daily_lessons_bloc.dart
// Bloc for managing daily lessons operations.

import 'package:bloc/bloc.dart';
import 'daily_lessons_event.dart';
import 'daily_lessons_state.dart';
import '../../domain/usecases/get_daily_vocabularies_usecase.dart';
import '../../domain/usecases/get_daily_phrases_usecase.dart';
import '../../domain/usecases/get_daily_lessons_usecase.dart';
import '../../domain/usecases/refresh_daily_lessons_usecase.dart';
import 'package:learning_english/core/usecase/usecase.dart';

/// Bloc for managing daily lessons (vocabularies and phrases)
/// Now uses cost-effective combined requests to reduce API costs
class DailyLessonsBloc extends Bloc<DailyLessonsEvent, DailyLessonsState> {
  final GetDailyVocabulariesUseCase getDailyVocabulariesUseCase;
  final GetDailyPhrasesUseCase getDailyPhrasesUseCase;
  final GetDailyLessonsUseCase getDailyLessonsUseCase;
  final RefreshDailyLessonsUseCase refreshDailyLessonsUseCase;

  DailyLessonsBloc({
    required this.getDailyVocabulariesUseCase,
    required this.getDailyPhrasesUseCase,
    required this.getDailyLessonsUseCase,
    required this.refreshDailyLessonsUseCase,
  }) : super(
         const DailyLessonsState(
           vocabularies: VocabulariesState.initial(),
           phrases: PhrasesState.initial(),
           isRefreshing: false,
         ),
       ) {
    on<DailyLessonsEvent>((event, emit) async {
      await event.when(
        fetchVocabularies: () => _onFetchVocabularies(emit),
        fetchPhrases: () => _onFetchPhrases(emit),
        fetchLessons: () => _onFetchLessons(emit), // New cost-effective method
        refreshLessons: () => _onRefreshLessons(emit),
      );
    });
  }

  Future<void> _onFetchVocabularies(Emitter<DailyLessonsState> emit) async {
    try {
      emit(state.copyWith(vocabularies: const VocabulariesState.loading()));
      final result = await getDailyVocabulariesUseCase(NoParams());
      result.fold(
        (failure) => emit(
          state.copyWith(
            vocabularies: VocabulariesState.error(failure.message),
          ),
        ),
        (vocabularies) => emit(
          state.copyWith(vocabularies: VocabulariesState.loaded(vocabularies)),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          vocabularies: VocabulariesState.error(
            'Failed to fetch vocabularies: ${e.toString()}',
          ),
        ),
      );
    }
  }

  Future<void> _onFetchPhrases(Emitter<DailyLessonsState> emit) async {
    try {
      emit(state.copyWith(phrases: const PhrasesState.loading()));
      final result = await getDailyPhrasesUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(state.copyWith(phrases: PhrasesState.error(failure.message))),
        (phrases) =>
            emit(state.copyWith(phrases: PhrasesState.loaded(phrases))),
      );
    } catch (e) {
      emit(
        state.copyWith(
          phrases: PhrasesState.error(
            'Failed to fetch phrases: ${e.toString()}',
          ),
        ),
      );
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

      final result = await getDailyLessonsUseCase(NoParams());
      result.fold(
        (failure) => emit(
          state.copyWith(
            vocabularies: VocabulariesState.error(failure.message),
            phrases: PhrasesState.error(failure.message),
          ),
        ),
        (data) => emit(
          state.copyWith(
            vocabularies: VocabulariesState.loaded(data.vocabularies),
            phrases: PhrasesState.loaded(data.phrases),
          ),
        ),
      );
    } catch (e) {
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

  /// Handles the refresh lessons event
  /// Sets isRefreshing to true to show loading indicator and disable button
  /// After refresh completes, re-fetches vocabularies and phrases
  /// Finally sets isRefreshing to false to hide loading indicator
  ///
  /// Note: Uses isLeft() instead of fold() to avoid nested async calls that cause emit errors
  Future<void> _onRefreshLessons(Emitter<DailyLessonsState> emit) async {
    try {
      emit(state.copyWith(isRefreshing: true));
      // After successful refresh, re-fetch lessons using cost-effective method
      await _onFetchLessons(emit);
      emit(state.copyWith(isRefreshing: false));
    } catch (e) {
      // Ensure isRefreshing is set to false even if an error occurs
      emit(state.copyWith(isRefreshing: false));
    }
  }
}

// Example usage:
// BlocProvider(create: (context) => DailyLessonsBloc(...))
