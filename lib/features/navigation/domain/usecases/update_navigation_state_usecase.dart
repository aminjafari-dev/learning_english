/// UpdateNavigationStateUseCase handles the business logic for updating navigation state.
///
/// This use case encapsulates the logic for updating the current navigation state
/// for a user, including their preferred tab and navigation preferences.
///
/// Usage Example:
///   final useCase = UpdateNavigationStateUseCase(repository);
///   final result = await useCase.call(UpdateNavigationStateParams(navigationState: state));
import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/features/navigation/domain/entities/navigation_state.dart';
import 'package:learning_english/features/navigation/domain/repositories/navigation_repository.dart';

/// Parameters for updating navigation state
class UpdateNavigationStateParams {
  /// The navigation state to update
  final NavigationState navigationState;

  const UpdateNavigationStateParams({required this.navigationState});
}

/// Use case for updating navigation state
class UpdateNavigationStateUseCase
    implements UseCase<NavigationState, UpdateNavigationStateParams> {
  /// Navigation repository instance
  final NavigationRepository _navigationRepository;

  const UpdateNavigationStateUseCase(this._navigationRepository);

  @override
  Future<Either<Failure, NavigationState>> call(
    UpdateNavigationStateParams params,
  ) async {
    try {
      final result = await _navigationRepository.updateNavigationState(
        params.navigationState,
      );
      return result;
    } catch (e) {
      return Left(
        ServerFailure('Failed to update navigation state: ${e.toString()}'),
      );
    }
  }
}
