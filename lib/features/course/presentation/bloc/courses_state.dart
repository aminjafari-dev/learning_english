// courses_state.dart
// Bloc states for the Courses feature, using freezed.
// Now includes user-specific data management and analytics states.

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/vocabulary.dart';
import '../../domain/entities/phrase.dart';
import '../../domain/entities/user_preferences.dart';

part 'courses_state.freezed.dart';

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
class UserPreferencesState with _$UserPreferencesState {
  const factory UserPreferencesState.initial() = UserPreferencesInitial;
  const factory UserPreferencesState.loading() = UserPreferencesLoading;
  const factory UserPreferencesState.loaded(UserPreferences preferences) =
      UserPreferencesLoaded;
  const factory UserPreferencesState.error(String message) =
      UserPreferencesError;
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
class CourseCompletionState with _$CourseCompletionState {
  const factory CourseCompletionState.initial() = CourseCompletionInitial;
  const factory CourseCompletionState.loading() = CourseCompletionLoading;
  const factory CourseCompletionState.completed({
    required String pathId,
    required int courseNumber,
  }) = CourseCompletionCompleted;
  const factory CourseCompletionState.error(String message) =
      CourseCompletionError;
}

@freezed
abstract class CoursesState with _$CoursesState {
  const factory CoursesState({
    required VocabulariesState vocabularies,
    required PhrasesState phrases,
    required UserPreferencesState userPreferences,
    required UserAnalyticsState analytics,
    required UserDataManagementState dataManagement,
    required CourseCompletionState courseCompletion,
    @Default(false) bool isRefreshing,
  }) = _CoursesState;
}

// Example usage:
// BlocBuilder<CoursesBloc, CoursesState>(builder: ...)
