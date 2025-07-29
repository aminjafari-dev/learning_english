import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/history_request.dart';
import '../entities/vocabulary_history_item.dart';
import '../entities/phrase_history_item.dart';

/// Abstract repository interface for vocabulary history operations.
/// This interface defines the contract for retrieving vocabulary and phrase history
/// from local storage, providing a clean abstraction for the domain layer.
///
/// Usage Example:
///   final repository = getIt<VocabularyHistoryRepository>();
///   final result = await repository.getHistoryRequests();
///   result.fold(
///     (failure) => print('Error: ${failure.message}'),
///     (requests) => print('Found ${requests.length} requests'),
///   );
///
/// This interface follows the dependency inversion principle and allows for
/// easy testing and implementation swapping.
abstract class VocabularyHistoryRepository {
  /// Retrieves all history requests grouped by request ID and creation date.
  /// This method fetches all vocabulary and phrase data from local storage
  /// and groups them by their request ID to create a comprehensive history view.
  ///
  /// Returns:
  /// - Right(List<HistoryRequest>): List of history requests with their vocabularies and phrases
  /// - Left(Failure): Error information if the operation fails
  ///
  /// Usage Example:
  ///   final result = await repository.getHistoryRequests();
  ///   result.fold(
  ///     (failure) => handleError(failure),
  ///     (requests) => displayHistory(requests),
  ///   );
  Future<Either<Failure, List<HistoryRequest>>> getHistoryRequests();

  /// Retrieves detailed vocabulary and phrase items for a specific request.
  /// This method fetches all vocabulary and phrase items that belong to
  /// a specific request ID, providing detailed information for the history view.
  ///
  /// Parameters:
  /// - requestId: The unique identifier of the request to fetch details for
  ///
  /// Returns:
  /// - Right(HistoryRequest): The complete request with all its vocabularies and phrases
  /// - Left(Failure): Error information if the operation fails
  ///
  /// Usage Example:
  ///   final result = await repository.getRequestDetails('req_123');
  ///   result.fold(
  ///     (failure) => handleError(failure),
  ///     (request) => displayRequestDetails(request),
  ///   );
  Future<Either<Failure, HistoryRequest>> getRequestDetails(String requestId);

  /// Retrieves all vocabulary history items for the current user.
  /// This method fetches all vocabulary items from local storage,
  /// regardless of their request grouping.
  ///
  /// Returns:
  /// - Right(List<VocabularyHistoryItem>): List of all vocabulary history items
  /// - Left(Failure): Error information if the operation fails
  ///
  /// Usage Example:
  ///   final result = await repository.getAllVocabularies();
  ///   result.fold(
  ///     (failure) => handleError(failure),
  ///     (vocabularies) => displayVocabularies(vocabularies),
  ///   );
  Future<Either<Failure, List<VocabularyHistoryItem>>> getAllVocabularies();

  /// Retrieves all phrase history items for the current user.
  /// This method fetches all phrase items from local storage,
  /// regardless of their request grouping.
  ///
  /// Returns:
  /// - Right(List<PhraseHistoryItem>): List of all phrase history items
  /// - Left(Failure): Error information if the operation fails
  ///
  /// Usage Example:
  ///   final result = await repository.getAllPhrases();
  ///   result.fold(
  ///     (failure) => handleError(failure),
  ///     (phrases) => displayPhrases(phrases),
  ///   );
  Future<Either<Failure, List<PhraseHistoryItem>>> getAllPhrases();

}
