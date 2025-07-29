import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../entities/history_request.dart';
import '../repositories/vocabulary_history_repository.dart';

/// Use case for retrieving all history requests from the repository.
/// This use case encapsulates the business logic for fetching and grouping
/// vocabulary and phrase history by request ID and creation date.
///
/// Usage Example:
///   final useCase = GetHistoryRequestsUseCase(repository);
///   final result = await useCase(NoParams());
///   result.fold(
///     (failure) => handleError(failure),
///     (requests) => displayHistory(requests),
///   );
///
/// This use case follows the single responsibility principle and provides
/// a clean interface for the presentation layer to access history data.
class GetHistoryRequestsUseCase
    implements UseCase<List<HistoryRequest>, NoParams> {
  final VocabularyHistoryRepository repository;

  /// Constructor for GetHistoryRequestsUseCase
  /// Requires a repository instance to perform data operations
  const GetHistoryRequestsUseCase(this.repository);

  /// Executes the use case to retrieve all history requests.
  /// This method calls the repository to fetch all vocabulary and phrase data,
  /// then groups them by request ID to create a comprehensive history view.
  ///
  /// Parameters:
  /// - params: NoParams - No parameters required for this operation
  ///
  /// Returns:
  /// - Right(List<HistoryRequest>): List of history requests with their vocabularies and phrases
  /// - Left(Failure): Error information if the operation fails
  ///
  /// Usage Example:
  ///   final result = await useCase(NoParams());
  ///   result.fold(
  ///     (failure) {
  ///       // Handle error case
  ///       print('Error: ${failure.message}');
  ///     },
  ///     (requests) {
  ///       // Handle success case
  ///       print('Found ${requests.length} history requests');
  ///       for (final request in requests) {
  ///         print('Request ${request.requestId}: ${request.totalItems} items');
  ///       }
  ///     },
  ///   );
  @override
  Future<Either<Failure, List<HistoryRequest>>> call(NoParams params) async {
    try {
      // Call the repository to get all history requests
      final result = await repository.getHistoryRequests();

      // Return the result directly (either success or failure)
      return result;
    } catch (e) {
      // Handle any unexpected errors and convert to Failure
      return Left(CacheFailure('Failed to get history requests: ${e.toString()}'));
    }
  }
}
