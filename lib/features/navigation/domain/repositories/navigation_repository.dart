/// NavigationRepository interface defines the contract for navigation operations.
///
/// This abstract repository provides methods for managing navigation state
/// and user preferences related to navigation.
///
/// Usage Example:
///   final repository = getIt<NavigationRepository>();
///   final state = await repository.getNavigationState('user123');
import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/features/navigation/domain/entities/navigation_state.dart';

/// Abstract repository interface for navigation operations
abstract class NavigationRepository {
  /// Retrieves the current navigation state for a user
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - Either<Failure, NavigationState>: The navigation state or failure
  Future<Either<Failure, NavigationState>> getNavigationState(String userId);

  /// Updates the navigation state for a user
  ///
  /// Parameters:
  ///   - navigationState: The navigation state to save
  ///
  /// Returns:
  ///   - Either<Failure, NavigationState>: The updated navigation state or failure
  Future<Either<Failure, NavigationState>> updateNavigationState(
    NavigationState navigationState,
  );

  /// Saves the current tab index for a user
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///   - currentIndex: The tab index to save
  ///
  /// Returns:
  ///   - Either<Failure, int>: The saved index or failure
  Future<Either<Failure, int>> saveCurrentIndex(
    String userId,
    int currentIndex,
  );

  /// Retrieves the saved current tab index for a user
  ///
  /// Parameters:
  ///   - userId: The unique identifier of the user
  ///
  /// Returns:
  ///   - Either<Failure, int>: The saved index or failure
  Future<Either<Failure, int>> getCurrentIndex(String userId);
}
