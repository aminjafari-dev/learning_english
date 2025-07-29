import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import '../entities/history_request.dart';
import '../repositories/vocabulary_history_repository.dart';

/// Parameters for getting request details
class GetRequestDetailsParams {
  /// The unique identifier of the request to fetch details for
  final String requestId;

  /// Constructor for GetRequestDetailsParams
  const GetRequestDetailsParams({required this.requestId});
}

/// Use case for retrieving detailed vocabulary and phrase items for a specific request.
/// This use case encapsulates the business logic for fetching all vocabulary and phrase
/// items that belong to a specific request ID.
///
/// Usage Example:
///   final useCase = GetRequestDetailsUseCase(repository);
///   final result = await useCase(GetRequestDetailsParams(requestId: 'req_123'));
///   result.fold(
///     (failure) => handleError(failure),
///     (request) => displayRequestDetails(request),
///   );
///
/// This use case follows the single responsibility principle and provides
/// a clean interface for the presentation layer to access detailed request data.
class GetRequestDetailsUseCase
    implements UseCase<HistoryRequest, GetRequestDetailsParams> {
  final VocabularyHistoryRepository repository;

  /// Constructor for GetRequestDetailsUseCase
  /// Requires a repository instance to perform data operations
  const GetRequestDetailsUseCase(this.repository);

  /// Executes the use case to retrieve detailed information for a specific request.
  /// This method calls the repository to fetch all vocabulary and phrase items
  /// that belong to the specified request ID.
  ///
  /// Parameters:
  /// - params: GetRequestDetailsParams containing the request ID to fetch details for
  ///
  /// Returns:
  /// - Right(HistoryRequest): The complete request with all its vocabularies and phrases
  /// - Left(Failure): Error information if the operation fails
  ///
  /// Usage Example:
  ///   final result = await useCase(GetRequestDetailsParams(requestId: 'req_123'));
  ///   result.fold(
  ///     (failure) {
  ///       // Handle error case
  ///       print('Error: ${failure.message}');
  ///     },
  ///     (request) {
  ///       // Handle success case
  ///       print('Request ${request.requestId}: ${request.totalItems} items');
  ///       print('Vocabularies: ${request.vocabularyCount}');
  ///       print('Phrases: ${request.phraseCount}');
  ///     },
  ///   );
  @override
  Future<Either<Failure, HistoryRequest>> call(
    GetRequestDetailsParams params,
  ) async {
    try {
      // Call the repository to get request details
      final result = await repository.getRequestDetails(params.requestId);

      // Return the result directly (either success or failure)
      return result;
    } catch (e) {
      // Handle any unexpected errors and convert to Failure
      return Left(
        CacheFailure('Failed to get request details: ${e.toString()}'),
      );
    }
  }
}
