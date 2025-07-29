/// GetNavigationStateUseCase handles the business logic for retrieving navigation state.
///
/// This use case encapsulates the logic for getting the current navigation state
/// for a user, including their preferred tab and navigation preferences.
///
/// Usage Example:
///   final useCase = GetNavigationStateUseCase(repository);
///   final result = await useCase.call(GetNavigationStateParams(userId: 'user123'));
import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/features/navigation/domain/entities/navigation_state.dart';
import 'package:learning_english/features/navigation/domain/repositories/navigation_repository.dart';

/// Parameters for getting navigation state
class GetNavigationStateParams {
  /// The unique identifier of the user
  final String userId;

  const GetNavigationStateParams({required this.userId});
}

/// Use case for retrieving navigation state
class GetNavigationStateUseCase
    implements UseCase<NavigationState, GetNavigationStateParams> {
  /// Navigation repository instance
  final NavigationRepository _navigationRepository;

  const GetNavigationStateUseCase(this._navigationRepository);

  @override
  Future<Either<Failure, NavigationState>> call(
    GetNavigationStateParams params,
  ) async {
    try {
      final result = await _navigationRepository.getNavigationState(
        params.userId,
      );
      return result;
    } catch (e) {
      return Left(
        ServerFailure('Failed to get navigation state: ${e.toString()}'),
      );
    }
  }
}
