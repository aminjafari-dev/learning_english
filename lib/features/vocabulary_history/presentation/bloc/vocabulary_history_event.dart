import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocabulary_history_event.freezed.dart';

/// Sealed class for vocabulary history-related events
/// This class defines all the events that can be triggered in the vocabulary history feature
///
/// Usage Example:
///   context.read<VocabularyHistoryBloc>().add(
///     const VocabularyHistoryEvent.loadHistoryRequests(),
///   );
///
/// This follows the event-driven architecture pattern and provides
/// type-safe event handling for the vocabulary history feature.
@freezed
class VocabularyHistoryEvent with _$VocabularyHistoryEvent {
  /// Event to load all history requests
  /// This event triggers the loading of all vocabulary and phrase history
  /// grouped by request ID and creation date
  const factory VocabularyHistoryEvent.loadHistoryRequests() =
      LoadHistoryRequests;

  /// Event to load details for a specific request
  /// This event triggers the loading of detailed vocabulary and phrase items
  /// for a specific request ID
  ///
  /// Parameters:
  /// - requestId: The unique identifier of the request to load details for
  const factory VocabularyHistoryEvent.loadRequestDetails({
    required String requestId,
  }) = LoadRequestDetails;

  /// Event to clear all history data
  /// This event triggers the clearing of all vocabulary and phrase history
  /// from local storage
  const factory VocabularyHistoryEvent.clearHistory() = ClearHistory;

  /// Event to refresh history data
  /// This event triggers a refresh of the current history data
  /// Useful for updating the UI after new data is added
  const factory VocabularyHistoryEvent.refreshHistory() = RefreshHistory;
}
