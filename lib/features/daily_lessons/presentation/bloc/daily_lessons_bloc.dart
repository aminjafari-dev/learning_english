// daily_lessons_bloc.dart
// Bloc for managing daily lessons operations.

import 'package:bloc/bloc.dart';
import 'daily_lessons_event.dart';
import 'daily_lessons_state.dart';
import '../../domain/usecases/get_daily_vocabularies_usecase.dart';
import '../../domain/usecases/get_daily_phrases_usecase.dart';
import '../../domain/usecases/refresh_daily_lessons_usecase.dart';
import 'package:learning_english/core/usecase/usecase.dart';

/// Bloc for managing daily lessons (vocabularies and phrases)
class DailyLessonsBloc extends Bloc<DailyLessonsEvent, DailyLessonsState> {
  final GetDailyVocabulariesUseCase getDailyVocabulariesUseCase;
  final GetDailyPhrasesUseCase getDailyPhrasesUseCase;
  final RefreshDailyLessonsUseCase refreshDailyLessonsUseCase;

  DailyLessonsBloc({
    required this.getDailyVocabulariesUseCase,
    required this.getDailyPhrasesUseCase,
    required this.refreshDailyLessonsUseCase,
  }) : super(const DailyLessonsState(
          vocabularies: VocabulariesState.initial(),
          phrases: PhrasesState.initial(),
        )) {
    on<DailyLessonsEvent>((event, emit) async {
      await event.when(
        fetchVocabularies: () => _onFetchVocabularies(emit),
        fetchPhrases: () => _onFetchPhrases(emit),
        refreshLessons: () => _onRefreshLessons(emit),
      );
    });
  }

  Future<void> _onFetchVocabularies(Emitter<DailyLessonsState> emit) async {
    emit(state.copyWith(vocabularies: const VocabulariesState.loading()));
    final result = await getDailyVocabulariesUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(vocabularies: VocabulariesState.error(failure.message))),
      (vocabularies) => emit(state.copyWith(vocabularies: VocabulariesState.loaded(vocabularies))),
    );
  }

  Future<void> _onFetchPhrases(Emitter<DailyLessonsState> emit) async {
    emit(state.copyWith(phrases: const PhrasesState.loading()));
    final result = await getDailyPhrasesUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(phrases: PhrasesState.error(failure.message))),
      (phrases) => emit(state.copyWith(phrases: PhrasesState.loaded(phrases))),
    );
  }

  Future<void> _onRefreshLessons(Emitter<DailyLessonsState> emit) async {
    emit(state.copyWith(isRefreshing: true));
    final result = await refreshDailyLessonsUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isRefreshing: false)),
      (_) async {
        // After refresh, re-fetch vocabularies and phrases
        await _onFetchVocabularies(emit);
        await _onFetchPhrases(emit);
        emit(state.copyWith(isRefreshing: false));
      },
    );
  }
}

// Example usage:
// BlocProvider(create: (context) => DailyLessonsBloc(...)) 