// daily_lessons_state.dart
// Bloc states for the Daily Lessons feature, using freezed.
// Now includes user-specific data management and analytics states.

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/vocabulary.dart';
import '../../domain/entities/phrase.dart';
import '../../data/models/conversation_thread_model.dart';

part 'daily_lessons_state.freezed.dart';

@freezed
class VocabulariesState with _$VocabulariesState {
  const factory VocabulariesState.initial() = VocabulariesInitial;
  const factory VocabulariesState.loading() = VocabulariesLoading;
  const factory VocabulariesState.loaded(List<Vocabulary> vocabularies) =
      VocabulariesLoaded;
  const factory VocabulariesState.error(String message) = VocabulariesError;
}

@freezed
class PhrasesState with _$PhrasesState {
  const factory PhrasesState.initial() = PhrasesInitial;
  const factory PhrasesState.loading() = PhrasesLoading;
  const factory PhrasesState.loaded(List<Phrase> phrases) = PhrasesLoaded;
  const factory PhrasesState.error(String message) = PhrasesError;
}

@freezed
class UserAnalyticsState with _$UserAnalyticsState {
  const factory UserAnalyticsState.initial() = UserAnalyticsInitial;
  const factory UserAnalyticsState.loading() = UserAnalyticsLoading;
  const factory UserAnalyticsState.loaded(Map<String, dynamic> analytics) =
      UserAnalyticsLoaded;
  const factory UserAnalyticsState.error(String message) = UserAnalyticsError;
}

@freezed
class UserDataManagementState with _$UserDataManagementState {
  const factory UserDataManagementState.initial() = UserDataManagementInitial;
  const factory UserDataManagementState.loading() = UserDataManagementLoading;
  const factory UserDataManagementState.success() = UserDataManagementSuccess;
  const factory UserDataManagementState.error(String message) =
      UserDataManagementError;
}

@freezed
class ConversationState with _$ConversationState {
  const factory ConversationState.initial() = ConversationInitial;
  const factory ConversationState.loading() = ConversationLoading;
  const factory ConversationState.loaded({
    required ConversationThreadModel? currentThread,
    required List<ConversationMessageModel> messages,
    required List<ConversationThreadModel> userThreads,
  }) = ConversationLoaded;
  const factory ConversationState.error(String message) = ConversationError;
}

@freezed
abstract class DailyLessonsState with _$DailyLessonsState {
  const factory DailyLessonsState({
    required VocabulariesState vocabularies,
    required PhrasesState phrases,
    required UserAnalyticsState analytics,
    required UserDataManagementState dataManagement,
    required ConversationState conversation,
    @Default(false) bool isRefreshing,
  }) = _DailyLessonsState;
}

// Example usage:
// BlocBuilder<DailyLessonsBloc, DailyLessonsState>(builder: ...)
