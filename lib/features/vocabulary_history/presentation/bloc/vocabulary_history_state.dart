import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/history_request.dart';

part 'vocabulary_history_state.freezed.dart';

/// State for loading history requests
@freezed
class HistoryRequestsState with _$HistoryRequestsState {
  /// Initial state when no data has been loaded
  const factory HistoryRequestsState.initial() = HistoryRequestsInitial;

  /// Loading state when fetching history requests
  const factory HistoryRequestsState.loading() = HistoryRequestsLoading;

  /// Completed state with loaded history requests
  const factory HistoryRequestsState.completed(List<HistoryRequest> requests) =
      HistoryRequestsCompleted;

  /// Error state when loading fails
  const factory HistoryRequestsState.error(String message) =
      HistoryRequestsError;
}

/// State for loading request details
@freezed
class RequestDetailsState with _$RequestDetailsState {
  /// Initial state when no details have been loaded
  const factory RequestDetailsState.initial() = RequestDetailsInitial;

  /// Loading state when fetching request details
  const factory RequestDetailsState.loading() = RequestDetailsLoading;

  /// Completed state with loaded request details
  const factory RequestDetailsState.completed(HistoryRequest request) =
      RequestDetailsCompleted;

  /// Error state when loading fails
  const factory RequestDetailsState.error(String message) = RequestDetailsError;
}

/// State for clearing history
@freezed
class ClearHistoryState with _$ClearHistoryState {
  /// Initial state when no clear operation has been performed
  const factory ClearHistoryState.initial() = ClearHistoryInitial;

  /// Loading state when clearing history
  const factory ClearHistoryState.loading() = ClearHistoryLoading;

  /// Completed state when history is cleared successfully
  const factory ClearHistoryState.completed() = ClearHistoryCompleted;

  /// Error state when clearing fails
  const factory ClearHistoryState.error(String message) = ClearHistoryError;
}

/// Main state combining all vocabulary history states
@freezed
class VocabularyHistoryState with _$VocabularyHistoryState {
  const factory VocabularyHistoryState({
    required HistoryRequestsState historyRequests,
    required RequestDetailsState requestDetails,
    required ClearHistoryState clearHistory,
  }) = _VocabularyHistoryState;
}
