import 'package:bloc/bloc.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../../domain/usecases/get_history_requests_usecase.dart';
import '../../domain/usecases/get_request_details_usecase.dart';
import '../../domain/repositories/vocabulary_history_repository.dart';
import 'vocabulary_history_event.dart';
import 'vocabulary_history_state.dart';

/// BLoC for managing vocabulary history operations
/// This BLoC handles all vocabulary history-related events and state management
///
/// Usage Example:
///   final bloc = VocabularyHistoryBloc(
///     getHistoryRequestsUseCase: getHistoryRequestsUseCase,
///     getRequestDetailsUseCase: getRequestDetailsUseCase,
///   );
///   bloc.add(const VocabularyHistoryEvent.loadHistoryRequests());
///
/// This BLoC follows the event-driven architecture pattern and provides
/// reactive state management for the vocabulary history feature.
class VocabularyHistoryBloc
    extends Bloc<VocabularyHistoryEvent, VocabularyHistoryState> {
  final GetHistoryRequestsUseCase getHistoryRequestsUseCase;
  final GetRequestDetailsUseCase getRequestDetailsUseCase;

  VocabularyHistoryBloc({
    required this.getHistoryRequestsUseCase,
    required this.getRequestDetailsUseCase,
  }) : super(
         VocabularyHistoryState(
           historyRequests: const HistoryRequestsState.initial(),
           requestDetails: const RequestDetailsState.initial(),
         ),
       ) {
    on<VocabularyHistoryEvent>((event, emit) async {
      await event.when(
        loadHistoryRequests: () => _onLoadHistoryRequests(emit),
        loadRequestDetails:
            (requestId) => _onLoadRequestDetails(requestId, emit),
        refreshHistory: () => _onRefreshHistory(emit),
      );
    });
  }

  /// Handles the LoadHistoryRequests event
  /// Fetches all history requests and updates the state accordingly
  Future<void> _onLoadHistoryRequests(
    Emitter<VocabularyHistoryState> emit,
  ) async {
    print('🔄 [HISTORY_BLOC] Loading history requests...');
    emit(state.copyWith(historyRequests: const HistoryRequestsState.loading()));

    try {
      print('🔄 [HISTORY_BLOC] Calling use case...');
      final result = await getHistoryRequestsUseCase(NoParams());

      result.fold(
        (failure) {
          print('❌ [HISTORY_BLOC] Use case failed: ${failure.message}');
          emit(
            state.copyWith(
              historyRequests: HistoryRequestsState.error(failure.message),
            ),
          );
        },
        (requests) {
          print(
            '✅ [HISTORY_BLOC] Use case succeeded with ${requests.length} requests',
          );
          emit(
            state.copyWith(
              historyRequests: HistoryRequestsState.completed(requests),
            ),
          );
        },
      );
    } catch (e) {
      print('❌ [HISTORY_BLOC] Exception in use case: $e');
      emit(
        state.copyWith(
          historyRequests: HistoryRequestsState.error(e.toString()),
        ),
      );
    }
  }

  /// Handles the LoadRequestDetails event
  /// Fetches detailed information for a specific request
  Future<void> _onLoadRequestDetails(
    String requestId,
    Emitter<VocabularyHistoryState> emit,
  ) async {
    emit(state.copyWith(requestDetails: const RequestDetailsState.loading()));

    try {
      final result = await getRequestDetailsUseCase(
        GetRequestDetailsParams(requestId: requestId),
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              requestDetails: RequestDetailsState.error(failure.message),
            ),
          );
        },
        (request) {
          emit(
            state.copyWith(
              requestDetails: RequestDetailsState.completed(request),
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(requestDetails: RequestDetailsState.error(e.toString())),
      );
    }
  }

  /// Handles the RefreshHistory event
  /// Refreshes the current history data
  Future<void> _onRefreshHistory(Emitter<VocabularyHistoryState> emit) async {
    // Reset states and reload history requests
    emit(
      VocabularyHistoryState(
        historyRequests: const HistoryRequestsState.loading(),
        requestDetails: const RequestDetailsState.initial(),
      ),
    );

    await _onLoadHistoryRequests(emit);
  }
}
