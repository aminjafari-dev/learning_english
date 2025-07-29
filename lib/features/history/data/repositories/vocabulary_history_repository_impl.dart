import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import '../../domain/entities/history_request.dart';
import '../../domain/entities/vocabulary_history_item.dart';
import '../../domain/entities/phrase_history_item.dart';
import '../../domain/repositories/vocabulary_history_repository.dart';
import '../datasources/local/vocabulary_history_local_data_source.dart';

/// Implementation of VocabularyHistoryRepository
/// This class implements the repository interface and handles the business logic
/// for retrieving vocabulary and phrase history from local storage.
///
/// Usage Example:
///   final repository = VocabularyHistoryRepositoryImpl(localDataSource);
///   final result = await repository.getHistoryRequests();
///   result.fold(
///     (failure) => handleError(failure),
///     (requests) => displayHistory(requests),
///   );
///
/// This implementation follows the repository pattern and provides
/// a clean abstraction for the domain layer.
class VocabularyHistoryRepositoryImpl implements VocabularyHistoryRepository {
  final VocabularyHistoryLocalDataSource localDataSource;

  /// Constructor for VocabularyHistoryRepositoryImpl
  /// Requires a local data source instance to perform data operations
  const VocabularyHistoryRepositoryImpl(this.localDataSource);

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
  @override
  Future<Either<Failure, List<HistoryRequest>>> getHistoryRequests() async {
    try {
      print('🔄 [HISTORY_REPO] Getting history requests...');

      // Ensure data source is initialized
      await localDataSource.initialize();
      print('🔄 [HISTORY_REPO] Data source initialized');

      // Get history requests from local data source
      final requests = await localDataSource.getHistoryRequests();
      print('🔄 [HISTORY_REPO] Retrieved ${requests.length} history requests');

      return Right(requests);
    } catch (e) {
      print('❌ [HISTORY_REPO] Error getting history requests: $e');
      // Handle any errors and convert to Failure
      return Left(
        CacheFailure('Failed to get history requests: ${e.toString()}'),
      );
    }
  }

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
  @override
  Future<Either<Failure, HistoryRequest>> getRequestDetails(
    String requestId,
  ) async {
    try {
      // Ensure data source is initialized
      await localDataSource.initialize();

      // Get request details from local data source
      final request = await localDataSource.getRequestDetails(requestId);

      return Right(request);
    } catch (e) {
      // Handle any errors and convert to Failure
      return Left(
        CacheFailure('Failed to get request details: ${e.toString()}'),
      );
    }
  }

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
  @override
  Future<Either<Failure, List<VocabularyHistoryItem>>>
  getAllVocabularies() async {
    try {
      // Ensure data source is initialized
      await localDataSource.initialize();

      // Get all vocabularies from local data source
      final vocabularies = await localDataSource.getAllVocabularies();

      return Right(vocabularies);
    } catch (e) {
      // Handle any errors and convert to Failure
      return Left(CacheFailure('Failed to get vocabularies: ${e.toString()}'));
    }
  }

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
  @override
  Future<Either<Failure, List<PhraseHistoryItem>>> getAllPhrases() async {
    try {
      // Ensure data source is initialized
      await localDataSource.initialize();

      // Get all phrases from local data source
      final phrases = await localDataSource.getAllPhrases();

      return Right(phrases);
    } catch (e) {
      // Handle any errors and convert to Failure
      return Left(CacheFailure('Failed to get phrases: ${e.toString()}'));
    }
  }

  /// Clears all history data for the current user.
  /// This method removes all vocabulary and phrase history from local storage,
  /// effectively resetting the user's learning history.
  ///
  /// Returns:
  /// - Right(Unit): Success confirmation
  /// - Left(Failure): Error information if the operation fails
  ///
  /// Usage Example:
  ///   final result = await repository.clearHistory();
  ///   result.fold(
  ///     (failure) => handleError(failure),
  ///     (_) => showSuccessMessage('History cleared successfully'),
  ///   );
  @override
  Future<Either<Failure, Unit>> clearHistory() async {
    try {
      // Ensure data source is initialized
      await localDataSource.initialize();

      // Clear history from local data source
      await localDataSource.clearHistory();

      return const Right(unit);
    } catch (e) {
      // Handle any errors and convert to Failure
      return Left(CacheFailure('Failed to clear history: ${e.toString()}'));
    }
  }
}
