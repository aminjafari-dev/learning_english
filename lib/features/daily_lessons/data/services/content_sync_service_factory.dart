// content_sync_service_factory.dart
// Simplified factory class that creates and manages the ContentSyncManager
// This factory provides a clean way to initialize and access the content sync functionality
// without the complex event-driven architecture.
//
// Usage:
//   final factory = ContentSyncServiceFactory(firebaseDataSource);
//   factory.initialize();
//   final manager = factory.getContentSyncManager();

import 'package:learning_english/features/daily_lessons/data/datasources/remote/firebase_lessons_remote_data_source.dart';
import 'content_sync_manager.dart';

/// Simplified factory for creating and managing content sync services
/// This factory creates a ContentSyncManager that directly uses FirebaseLessonsRemoteDataSource
class ContentSyncServiceFactory {
  final FirebaseLessonsRemoteDataSource _firebaseDataSource;
  ContentSyncManager? _contentSyncManager;
  bool _isInitialized = false;

  /// Constructor requires Firebase remote data source instance
  ContentSyncServiceFactory({
    required FirebaseLessonsRemoteDataSource firebaseDataSource,
  }) : _firebaseDataSource = firebaseDataSource;

  /// Initializes the content sync services
  /// This creates the ContentSyncManager and initializes it
  void initialize() {
    if (_isInitialized) {
      print('⚠️ [FACTORY] Content sync services already initialized');
      return;
    }

    print('🔄 [FACTORY] Initializing content sync services...');

    // Create content sync manager
    _contentSyncManager = createContentSyncManager();

    // Initialize manager
    print('🔄 [FACTORY] Initializing content sync manager...');
    _contentSyncManager!.initialize();

    _isInitialized = true;
    print('✅ [FACTORY] Content sync services initialized successfully');
  }

  /// Creates a new ContentSyncManager instance
  /// This manager directly uses FirebaseLessonsRemoteDataSource for saving content
  ///
  /// Returns: ContentSyncManager instance
  ContentSyncManager createContentSyncManager() {
    print('🔄 [FACTORY] Creating content sync manager...');
    final manager = ContentSyncManager(firebaseDataSource: _firebaseDataSource);
    print('✅ [FACTORY] Content sync manager created successfully');
    return manager;
  }

  /// Gets the initialized ContentSyncManager instance
  /// This method should be called after initialize() to get the manager
  ///
  /// Returns: ContentSyncManager instance or null if not initialized
  ContentSyncManager? getContentSyncManager() {
    if (!_isInitialized) {
      print('⚠️ [FACTORY] Services not initialized, returning null');
      return null;
    }
    return _contentSyncManager;
  }

  /// Checks if the services are initialized
  ///
  /// Returns: true if initialized, false otherwise
  bool get isInitialized => _isInitialized;

  /// Disposes of the factory and cleans up resources
  /// This should be called when the factory is no longer needed
  void dispose() {
    print('🔄 [FACTORY] Disposing content sync service factory...');

    if (_contentSyncManager != null) {
      _contentSyncManager!.dispose();
      _contentSyncManager = null;
    }

    _isInitialized = false;
    print('✅ [FACTORY] Content sync service factory disposed');
  }
}

// Example usage:
// final factory = ContentSyncServiceFactory(firebaseDataSource);
// factory.initialize();
//
// final manager = factory.getContentSyncManager();
// if (manager != null) {
//   manager.saveContentToFirebase(
//     vocabularies: newVocabularies,
//     phrases: newPhrases,
//     context: learningContext,
//     userId: 'user123',
//   );
// }
