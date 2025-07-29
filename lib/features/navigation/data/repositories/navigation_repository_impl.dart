/// NavigationRepositoryImpl implements the NavigationRepository interface.
///
/// This class coordinates between local data sources and provides
/// a unified interface for navigation state management.
///
/// Usage Example:
///   final repository = NavigationRepositoryImpl(localDataSource: localDataSource);
///   final state = await repository.getNavigationState('user123');
import 'package:dartz/dartz.dart';
import 'package:learning_english/core/error/failure.dart';
import 'package:learning_english/features/navigation/data/datasources/navigation_local_data_source.dart';
import 'package:learning_english/features/navigation/data/models/navigation_state_model.dart';
import 'package:learning_english/features/navigation/domain/entities/navigation_state.dart';
import 'package:learning_english/features/navigation/domain/repositories/navigation_repository.dart';

/// Implementation of NavigationRepository
class NavigationRepositoryImpl implements NavigationRepository {
  /// Local data source for navigation operations
  final NavigationLocalDataSource _localDataSource;

  /// Constructor for NavigationRepositoryImpl
  ///
  /// Parameters:
  ///   - localDataSource: Local data source for navigation operations
  const NavigationRepositoryImpl({
    required NavigationLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  @override
  Future<Either<Failure, NavigationState>> getNavigationState(
    String userId,
  ) async {
    try {
      final cachedState = await _localDataSource.getCachedNavigationState(
        userId,
      );
      if (cachedState != null) {
        return Right(cachedState.toDomain());
      }

      // Return default state if no cached state exists
      final defaultState = NavigationStateModel(
        currentIndex: 0,
        userId: userId,
        lastUpdated: DateTime.now().toIso8601String(),
      );

      await _localDataSource.cacheNavigationState(defaultState);
      return Right(defaultState.toDomain());
    } catch (e) {
      return Left(
        CacheFailure('Failed to get navigation state: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, NavigationState>> updateNavigationState(
    NavigationState navigationState,
  ) async {
    try {
      final navigationStateModel = NavigationStateModel(
        currentIndex: navigationState.currentIndex,
        userId: navigationState.userId,
        lastUpdated: navigationState.lastUpdated.toIso8601String(),
      );

      await _localDataSource.cacheNavigationState(navigationStateModel);
      return Right(navigationState);
    } catch (e) {
      return Left(
        CacheFailure('Failed to update navigation state: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, int>> saveCurrentIndex(
    String userId,
    int currentIndex,
  ) async {
    try {
      final success = await _localDataSource.saveCurrentIndex(
        userId,
        currentIndex,
      );
      if (success) {
        return Right(currentIndex);
      } else {
        return Left(CacheFailure('Failed to save current index'));
      }
    } catch (e) {
      return Left(
        CacheFailure('Failed to save current index: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, int>> getCurrentIndex(String userId) async {
    try {
      final currentIndex = await _localDataSource.getCurrentIndex(userId);
      return Right(currentIndex);
    } catch (e) {
      return Left(CacheFailure('Failed to get current index: ${e.toString()}'));
    }
  }
}
